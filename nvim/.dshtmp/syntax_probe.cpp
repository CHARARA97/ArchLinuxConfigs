// ============ 1. 哪种注释会被注入 doxygen ============
/** multiline, 触发 doxygen 注入 */
int a1;
/*! multiline with bang, 触发 */
int a2;
/// triple slash, 触发
int a3;
//! bang slash, 触发
int a4;
///< trailing member doc, 触发
int a5;
int a6; ///< trailing member doc, 触发
int a7; /**< trailing member doc, 触发 */
///no-space-after-slashes，不触发（第 4 个字符是字母）
int a8;
/**no-space-after-stars，不触发 */
int a9;
/* ordinary block comment, 不触发 doxygen，只走 comment parser */
int a10;

// ============ 2. 普通注释里的关键字（comment parser）============
// TODO: implement this
// FIXME: broken
// XXX: check
// HACK: workaround
// NOTE: keep in sync
// WARNING: deprecated
// BUG: known issue
// PERF: hot path
// TEST: temp
// DOCS: see manual
// INFO: extra
// WIP: not done
// TODO(zoe): assign to user
// see issue #123 for details
// https://example.com/docs

// ============ 3. 标签名（tag_name）============
/**
 * @brief 简短描述（doxygen 有专门解析）
 * \brief 反斜杠写法等价
 * @details 详细描述
 * @return 返回值说明
 * @note 提示、@warning 警告、@todo 待办
 * @author 作者、@date 日期、@version 版本
 * @custom_unknown_tag 任意未知标签也是 tag_name
 * @{  分组开始
 * @}  分组结束
 */

// ============ 4. 带参数的标签 ============
/**
 * @param x 单参数
 * @param[in]  y 输入参数
 * @param[out] z 输出参数
 * @param[inout] w 输入输出参数
 * @namespace ns_name 命名空间
 * @exception std::runtime_error 抛出的异常
 */

// ============ 5. 带类型的标签（类型部分会再注入回 cpp）============
/**
 * @fn void foo(int)
 * @var int my_var
 * @typedef std::vector<int> Vec
 * @property int value
 * @overload void bar()
 * @class MyClass
 * @defgroup group_name 分组
 * @sa foo() bar()
 */

// ============ 6. 描述里的行内语法 ============
/**
 * 普通文字 \a emphasized 强调（\a 后面的词）
 * @em at-em 不是行内语法，只是标签
 * <em>html em</em> 也不是
 * 行内代码 \c code_word 会注入回 cpp
 * 函数引用 foo() 与 ::bar 与 A::b()
 * 限定名 ns::thing 和标点 . , ~ ( ) { } [ ]
 * 链接 <a href="https://example.com">example</a>
 * @ref A::method 引用
 * @see foo() for details
 */

// ============ 7. 代码块 ============
/**
 * @code{.cpp}
 * std::vector<int> v = {1, 2, 3};
 * @endcode
 * @code
 * plain_code_no_language = 1;
 * @endcode
 * ```cpp
 * auto x = std::string("fenced");
 * ```
 */

// ============ 8. 其它注入 ============
/*!re2c
    "abc" { return 1; }
*/
int a11;
