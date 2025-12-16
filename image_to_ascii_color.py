#!/usr/bin/env python3
"""
图片转彩色ASCII艺术工具 (for Fastfetch Logo)
用法：python3 image_to_ascii_color.py 图片路径 [输出宽度]
"""

import sys
import os
from PIL import Image  # 需要安装Pillow库

def main(image_path, output_width=40):
    """
    主转换函数
    :param image_path: 输入图片的路径
    :param output_width: 输出ASCII艺术的宽度（字符数）
    """
    # 1. 定义字符集：从最暗（'@'）到最亮（' '空格）
    # 你可以调整这个字符串来改变字符的“密度”和风格
    # 例如："@%#*+=-:. " 或 "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'. "
    ascii_chars = "▇ "

    try:
        # 2. 打开并转换图片
        img = Image.open(image_path)
        # 转换为RGB模式，确保有颜色信息
        img = img.convert("RGB")
        
        # 3. 根据目标宽度计算高度，保持宽高比
        original_width, original_height = img.size
        aspect_ratio = original_height / original_width
        output_height = int(output_width * aspect_ratio * 0.55)  # 乘0.55是因为终端字符通常不是正方形
        
        # 缩放图片到目标尺寸
        img = img.resize((output_width, output_height), Image.Resampling.LANCZOS)
        
        # 4. 转换为灰度图，用于选择ASCII字符
        gray_img = img.convert("L")  # L模式表示灰度
        
        # 5. 构建彩色ASCII字符串
        ascii_art_lines = []
        for y in range(output_height):
            line = ""
            for x in range(output_width):
                # 获取灰度值 (0-255)
                gray_value = gray_img.getpixel((x, y))
                # 根据灰度值选择字符
                char_index = int(gray_value / 255 * (len(ascii_chars) - 1))
                ascii_char = ascii_chars[char_index]
                
                # 获取原始像素的RGB颜色
                r, g, b = img.getpixel((x, y))
                # 生成ANSI 真彩色（24位）转义序列
                # 格式: \u001b[38;2;R;G;Bm
                color_prefix = f"\u001b[38;2;{r};{g};{b}m"
                color_suffix = "\u001b[0m"  # 重置颜色
                
                # 将彩色字符添加到行中
                line += f"{color_prefix}{ascii_char}{color_suffix}"
            ascii_art_lines.append(line)
        
        # 6. 将结果写入文件
        output_filename = os.path.splitext(os.path.basename(image_path))[0] + "_color_ascii.txt"
        with open(output_filename, "w", encoding="utf-8") as f:
            f.write("\n".join(ascii_art_lines))
        
        # 7. 在终端中预览（可选）
        print("转换成功！预览如下：")
        print("\n".join(ascii_art_lines[:min(20, output_height)]))  # 最多预览20行
        print(f"\n完整ASCII艺术已保存到文件: {output_filename}")
        print(f"你可以将它用于Fastfetch配置: fastfetch --logo {output_filename}")
        
    except FileNotFoundError:
        print(f"错误：找不到文件 '{image_path}'")
        sys.exit(1)
    except Exception as e:
        print(f"处理图片时发生错误: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # 解析命令行参数
    if len(sys.argv) < 2:
        print(__doc__)
        print("\n示例:")
        print("  python3 image_to_ascii_color.py avatar.jpg")
        print("  python3 image_to_ascii_color.py landscape.png 60")
        sys.exit(1)
    
    image_path = sys.argv[1]
    output_width = int(sys.argv[2]) if len(sys.argv) > 2 else 40
    
    main(image_path, output_width)