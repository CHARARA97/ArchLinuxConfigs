#ifndef DVORAK_PRACTICE_ARTICLE_H
#define DVORAK_PRACTICE_ARTICLE_H

#include <string>
#include <vector>

// ──────────────────────────────────────────────
// 文章文件信息
// ──────────────────────────────────────────────
struct ArticleInfo {
    std::string filename;       // 文件名（不含路径）
    std::string full_path;      // 完整路径
    int char_count = 0;         // 总字符数（不含空白压缩后）
    int paragraph_count = 0;    // 段落数
};

// ──────────────────────────────────────────────
// 文章加载结果
// ──────────────────────────────────────────────
struct ArticleLoadResult {
    bool success;
    std::string error_msg;
    std::vector<std::string> paragraphs;  // 段落数组（每段为压平后的文本）
};

// ──────────────────────────────────────────────
// 文章管理器
// ──────────────────────────────────────────────
class ArticleManager {
public:
    // 扫描文章目录，返回所有可用文章文件
    static std::vector<ArticleInfo> list_available();

    // 加载指定文章：段落化 + 规范化
    // 规则：
    //   1. 空行分隔段落
    //   2. 段落内的换行折叠为空格，连续空白压缩为单个空格
    //   3. 保留大小写、数字、标点
    static ArticleLoadResult load(const std::string& path);
};

#endif // DVORAK_PRACTICE_ARTICLE_H
