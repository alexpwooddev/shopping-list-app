import React, {useState, useEffect} from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';

import { ListItems, ListItem, ProductSearchPanel, Spinner, ErrorMessage, ImageUpload } from './';

const ListPanel = () => {
    const [listItems, setListItems] = useState([]);
    const [products, setProducts] = useState([]);
    const [hideCompletedListItems, setHideCompletedListItems] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [errorMessage, setErrorMessage] = useState(null);
    const listId = window.location.pathname.split('/')[2];
    const listItemsPath = `/api/v1/lists/${listId}/list_items`;
    const productsPath = `/api/v1/products`;

    useEffect(() => {
        getListItems();
        getProducts();
    }, []);

    //TO DO  - refine this so I don't need to request ALL products from the API
    const getProducts = () => {
        axios.get(productsPath)
            .then(response => {
                clearErrors();
                setIsLoading(true);
                const retrievedProducts = response.data;
                setProducts(retrievedProducts);
                setIsLoading(false);
            })
            .catch(error => {
                console.log(error);
                setIsLoading(true);
                setErrorMessage( {message: "There was an error loading your list..."})
            });
    }

    const getListItems = () => {
        axios.get(listItemsPath)
            .then(response => {
                clearErrors();
                setIsLoading(true);
                const retrievedListItems = response.data;
                setListItems(retrievedListItems);
                setIsLoading(false);
            })
            .catch(error => {
                console.log(error);
                setIsLoading(true);
                setErrorMessage({message: "There was an error loading your list..."});
            });
    }

    const createListItem = (listItem) => {
        const newListItems = [listItem, ...listItems];
        setListItems(newListItems);
    }

    const toggleCompletedListItems = () => {
        setHideCompletedListItems(!hideCompletedListItems);
    }

    const handleErrors = (errorMessage) => {
        setErrorMessage(errorMessage);
    }

    const clearErrors = () => {
        setErrorMessage(null);
    }

    return (
        <>
            {errorMessage && (
                <ErrorMessage errorMessage={errorMessage}/>
            )}
            {!isLoading && (
                <>
                    <ImageUpload />
                    <ProductSearchPanel
                        createListItem={createListItem}
                        listId={listId}
                        handleErrors={handleErrors}
                        clearErrors={clearErrors}
                        products={products}
                    />
                    <ListItems
                        toggleCompletedListItems={toggleCompletedListItems}
                        hideCompletedListItems={hideCompletedListItems}>
                        {listItems.map(item => (
                            <ListItem
                                key={item.id}
                                listId={listId}
                                listItem={item}
                                products={products}
                                getListItems={getListItems}
                                hideCompletedListItems={hideCompletedListItems}
                                handleErrors={handleErrors}
                                clearErrors={clearErrors}
                            />
                        ))}
                    </ListItems>
                </>
            )}
            {isLoading && <Spinner />}
        </>
    );
}

export default ListPanel;

document.addEventListener('turbolinks:load', () => {
    const app = document.getElementById('list-panel');
    app && ReactDOM.render(<ListPanel/>, app);
})
