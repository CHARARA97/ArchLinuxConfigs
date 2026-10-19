/**
 * @brief Multi-line doxygen doc comment
 * @param x the input value
 * @return the doubled value
 * @note this is a note
 * @warning careful
 * @todo fix me
 */
int foo(int x);

/** @brief Single-line doc comment with @param x */
int bar(int x);

//! @brief Qt-style doc comment
int baz(int x);

/// @brief Triple-slash doc comment
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
