import React from 'react';
import PropTypes from 'prop-types'

const SearchBar = ({searchQuery, setSearchQuery, toggleSearchFocus}) => {
    const onSubmit = e => {
        e.preventDefault();
    }

    return (
        <>
            <form
                className="mt-3"
                action="/"
                method="get"
                autoComplete="off"
                onFocus={toggleSearchFocus}
                onBlur={toggleSearchFocus}
                onSubmit={onSubmit}
            >
                <label htmlFor="product-search">
                    Search for products and click to add them:
                </label>
                <input
                    value={searchQuery}
                    onInput={e => setSearchQuery(e.target.value)}
                    type="text"
                    id="product-search"
                    placeholder="Search..."
                    className="form-control"
                    name="s"
                />
            </form>
        </>
    )

}

export default SearchBar;

SearchBar.propTypes = {
    searchQuery: PropTypes.string.isRequired,
    setSearchQuery: PropTypes.func.isRequired,
    toggleSearchFocus: PropTypes.func.isRequired,
}