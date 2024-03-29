import React, {useState} from 'react';
import PropTypes from 'prop-types';
import { doAxiosPost } from '../utils/doAxiosPost';

import {SearchBar, setAxiosHeaders} from './';

const filterProducts = (products, query) => {
    if (!query) {
        return products;
    }

    return products.filter((product) => {
        const productName = product.name.toLowerCase();
        return productName.includes(query);
    });
};


const ProductSearchPanel = ({createListItem, updateListItem, listId, handleErrors, clearErrors, products}) => {
    const {search} = window.location;
    const query = new URLSearchParams(search).get('s');
    const [searchQuery, setSearchQuery] = useState(query || '');
    const [searchFocused, setSearchFocused] = useState(false);
    const filteredProducts = filterProducts(products, searchQuery);
    const path = `/api/v1/lists/${listId}/list_items`

    const toggleSearchFocus = () => setSearchFocused(!searchFocused);

    const handleProductClick = (e, productId) => {
        e.preventDefault();
        setAxiosHeaders();
        doAxiosPost(path, productId, createListItem, updateListItem, clearErrors, handleErrors);
        setSearchQuery('');
    }

    return (
        <>
            <SearchBar
                searchQuery={searchQuery}
                setSearchQuery={setSearchQuery}
                toggleSearchFocus={toggleSearchFocus}
            />
            {searchFocused &&
            <div className="list-group">
                {filteredProducts.map((product) => (
                    <button
                        key={product.id}
                        id={product.id}
                        className="list-group-item list-group-item-action"
                        onClick={(e) => {
                            handleProductClick(e, product.id)
                        }}
                        onMouseDown={(e) => e.preventDefault()}
                    >
                        {product.name}
                    </button>
                ))}
            </div>}
        </>
    )
}

export default ProductSearchPanel

ProductSearchPanel.propTypes = {
    createListItem: PropTypes.func.isRequired,
    handleErrors: PropTypes.func.isRequired,
    clearErrors: PropTypes.func.isRequired,
    listId: PropTypes.string.isRequired,
    products: PropTypes.array.isRequired,
}

