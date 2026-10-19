/**
 * @brief Multi-line doxygen doc comment
 * @param x the input value
 * @return the doubled value
 * @note this is a note
 * @warning careful
 * @todo fix me
 * @see foo() for details
 * @ref A::method
 * @em emphasis here and <em>html emphasis</em>
 * \a arg and \c code
 * @code{.cpp}
 * std::vector<int> v = {1, 2, 3};
 * v.push_back(4);
 * @endcode
 * @param[in]  y in-mode parameter
 * @param[out] z out-mode parameter
 * obj.method() and ns::thing are referenced here
 */
int foo(int x);

/** @brief Single-line doc comment with @param x */
int bar(int x);

//! @brief Qt-style doc comment
int baz(int x);

/// @brief Triple-slash doc comment, @param x and @return y
int qux(int x);

/* @brief ordinary block comment, not a doc comment */
int nope(int x);

// ordinary line comment mentioning @brief
int maybe(int x);

class A {
public:
    /*! @brief member doc */
    void method();
};
