// ===== A. 各种注释标记 + tag，验证注入是否生效 =====
/** @brief A1 stars */
int b1;
/*! @brief A2 bang */
int b2;
/// @brief A3 triple
int b3;
//! @brief A4 slash-bang
int b4;
///< @brief A5 trailing triple
int b5;
int b6; ///< @brief A6 trailing triple
//!< @brief A7 trailing bang
int b7;
///@brief A8 triple no space
int b8;
///no-space @brief A9 word then tag
int b9;
/**@brief A10 stars no space */
int b10;
/* @brief A11 ordinary block */
int b11;
// @brief A12 ordinary line
int b12;

// ===== B. \a emphasis 的生效条件 =====
/**
 * \a start_of_line
 * text before \a mid_text after
 * 中文 \a cjk_before after
 * @brief brief desc with \a inside_brief
 * @param x desc with \a inside_param_desc
 * @note note desc with \a inside_note
 */

// ===== C. \c 与函数引用 =====
/**
 * \c at_start
 * text before \c mid_text
 * @brief desc \c inside_brief
 * @see foo() bar() ::baz A::qux()
 * free text foo() ::bar A::b()
 */

// ===== D. <a href> 链接 =====
/**
 * <a href="https://a.example">at line start</a>
 * text before <a href="https://b.example">mid line</a>
 * @brief <a href="https://c.example">inside brief</a>
 */

// ===== E. 文档注释里的 comment-parser 关键字 =====
/**
 * TODO: bare todo in doc comment
 * FIXME: bare fixme, see #42
 * https://d.example/url
 */

// ===== F. @param 的修饰符 =====
/**
 * @param[in,out] p comma form
 * @param[in] q in form
 */

// ===== G. fenced code block =====
/** ```cpp
 * auto fenced_same_line = 1;
 * ```
 */
int c1;
/** @brief G2
 * ```cpp
 * auto fenced = 2;
 * ```
 */
int c2;
/// ```cpp auto fenced_single = 3; ```
int c3;
