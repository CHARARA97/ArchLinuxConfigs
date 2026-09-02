#include "article.h"
#include "config.h"
#include <fstream>
#include <filesystem>
#include <algorithm>
#include <cctype>

namespace fs = std::filesystem;

// ──────────────────────────────────────────────
// 列出文章目录中的所有可用文件
// ──────────────────────────────────────────────
std::vector<ArticleInfo> ArticleManager::list_available()
{
    std::vector<ArticleInfo> result;
    std::string dir_path = ConfigManager::get_article_dir();

    if (!fs::exists(dir_path)) return result;

    for (const auto& entry : fs::directory_iterator(dir_path)) {
        if (!entry.is_regular_file()) continue;
        std::string ext = entry.path().extension().string();
        if (ext != ".txt" && ext != ".md" && ext != ".text") continue;

        ArticleInfo info;
        info.filename  = entry.path().filename().string();
        info.full_path = entry.path().string();

        // 粗略统计
        auto loaded = load(info.full_path);
        if (loaded.success) {
            info.paragraph_count = static_cast<int>(loaded.paragraphs.size());
            int chars = 0;
            for (const auto& p : loaded.paragraphs) chars += static_cast<int>(p.size());
            info.char_count = chars;
        }
        result.push_back(info);
    }

    std::sort(result.begin(), result.end(),
        [](const ArticleInfo& a, const ArticleInfo& b) { return a.filename < b.filename; });
    return result;
}

// ──────────────────────────────────────────────
// 加载文章，处理为段落数组
// ──────────────────────────────────────────────
ArticleLoadResult ArticleManager::load(const std::string& path)
{
    ArticleLoadResult result;
    result.success = false;

    std::ifstream fin(path);
    if (!fin.good()) {
        result.error_msg = "无法打开文章文件: " + path;
        return result;
    }

    // 读入所有行
    std::vector<std::string> raw_lines;
    std::string line;
    while (std::getline(fin, line)) {
        raw_lines.push_back(line);
    }
    if (raw_lines.empty()) {
        result.error_msg = "文章文件为空: " + path;
        return result;
    }

    // 空行分段
    auto trim_right = [](const std::string& s) {
        auto e = s.find_last_not_of(" \t\r");
        return (e == std::string::npos) ? std::string() : s.substr(0, e + 1);
    };
    auto trim_both = [](const std::string& s) {
        auto b = s.find_first_not_of(" \t\r");
        auto e = s.find_last_not_of(" \t\r");
        return (b == std::string::npos) ? std::string() : s.substr(b, e - b + 1);
    };

    std::vector<std::string> paragraphs;
    std::string cur;
    for (const auto& raw : raw_lines) {
        if (trim_both(raw).empty()) {
            // 空行 → 结束当前段落
            if (!trim_both(cur).empty()) {
                paragraphs.push_back(trim_both(cur));
            }
            cur.clear();
        } else {
            if (!cur.empty()) cur += " ";   // 段内换行折叠为空格
            cur += trim_right(raw);
        }
    }
    if (!trim_both(cur).empty()) {
        paragraphs.push_back(trim_both(cur));
    }

    if (paragraphs.empty()) {
        result.error_msg = "文章中没有可练习的内容: " + path;
        return result;
    }

    // 压缩段内连续空白
    for (auto& p : paragraphs) {
        std::string out;
        out.reserve(p.size());
        bool prev_space = false;
        for (char c : p) {
            if (c == ' ' || c == '\t') {
                if (!prev_space) out += ' ';
                prev_space = true;
            } else {
                out += c;
                prev_space = false;
            }
        }
        p = trim_both(out);
    }
    // 移除空段落
    paragraphs.erase(
        std::remove_if(paragraphs.begin(), paragraphs.end(),
            [](const std::string& s) { return s.empty(); }),
        paragraphs.end());

    result.success = true;
    result.paragraphs = std::move(paragraphs);
    return result;
}
