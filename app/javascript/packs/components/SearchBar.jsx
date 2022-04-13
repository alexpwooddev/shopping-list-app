import React from 'react';
import PropTypes from 'prop-types'

const SearchBar = ({ searchQuery, setSearchQuery, toggleSearchFocus }) => {
    const onSubmit = e => {
        e.preventDefault();
    }

    return (
        <form action="/" method="get" autoComplete="off" onFocus={toggleSearchFocus} onBlur={toggleSearchFocus} onSubmit={onSubmit}>
            <label htmlFor="product-search">
                <span className="visually-hidden">Search Products and click to add them to your list...</span>
            </label>
            <input
                value={searchQuery}
                onInput={e => setSearchQuery(e.target.value)}
                type="text"
                id="product-search"
                placeholder="Search Products and click to add them to your list..."
                className="form-control"
                name="s"
            />
        </form>
    )

}

export default SearchBar;

SearchBar.propTypes = {
    searchQuery: PropTypes.string.isRequired,
    setSearchQuery: PropTypes.func.isRequired,
    toggleSearchFocus: PropTypes.func.isRequired,
}