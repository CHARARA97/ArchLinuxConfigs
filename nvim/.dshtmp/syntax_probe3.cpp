// ===== \a 失效复现 =====
/**
 * 普通文字 \a emphasized 强调
 * 普通文字 \a emphasized 强调（\a 后面的词）
 * one \a first two \a second three
 * 强调（x）\a arg
 */

// ===== 对照：完全正常的一组 =====
/**
 * \a start_of_line
 * text before \a mid_text after
 * 中文 \a cjk_before after
 */

// ===== fenced 对齐测试 =====
/**
```cpp
auto aligned = 1;
```
*/
int d1;
