/**
 * \a emphasis_word
 * \c int
 * <a href="https://example.com">example link</a>
 * @brief Brief description of the function.
 * @details Longer description of what it does.
 * @param[in]  in_val   Input value.
 * @param[out] out_val  Output value.
 * @param[inout] both   Read and written.
 * @tparam T          Template parameter.
 * @retval 0          Success.
 * @return Result code.
 * @note A note with \a emphasis_in_note, @warning a warning, @todo a todo.
 * @see foo() and @ref A::method
 * @author name, @date 2026-01-01, @version 1.0
 * @custom_unknown_tag any unknown tag is still a tag_name
 * @{ group start, @} group end
 * @code{.cpp}
 * std::vector<int> v = {1, 2, 3};
 * @endcode
 */
int foo(int in_val, int* out_val);

/*! @brief Bang-style block comment
 * @param x bang style is injected too
 * @sa foo() bar()
 */
int bang(int x);

//! @brief Bang-style line comment with @param x
int bang_line(int x);

/// @brief Triple-slash comment with @return and @note
int triple(int x);

//!< @brief trailing bang doc
int trailing;

/**< @brief trailing stars doc */
int trailing2;

/** @brief Single-line doc comment with @param x */
int single(int x);

// TODO: plain comment tag
// FIXME: broken, see issue #42
// XXX: check this
// HACK: workaround
// NOTE: keep in sync
// WARNING: deprecated
// PERF: hot path
// https://example.com/docs

/* ordinary comment: @brief is NOT highlighted here */
int ordinary;
