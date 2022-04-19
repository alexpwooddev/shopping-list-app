import React, {useState, useEffect} from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';
import {ToastContainer, toast} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

import {ListItems, ListItem, ProductSearchPanel, Spinner, ErrorMessage, ImageUpload} from './';

const ListPanel = () => {
    const [listItems, setListItems] = useState([]);
    const [products, setProducts] = useState([]);
    const [hideCompletedListItems, setHideCompletedListItems] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [errorMessage, setErrorMessage] = useState(null);
    const listId = window.location.pathname.split('/')[2];
    const listItemsPath = `/api/v1/lists/${listId}/list_items`;
    const productsPath = `/api/v1/products`;

    const notifyItemsAdded = () => toast.success("Item/s added");
    const notifyItemUpdated = () => toast.success("Item updated");
    const notifyNoItemsMatched = () => toast.error("No valid products found in image")

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
                setErrorMessage({message: "There was an error loading your list..."})
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

    const createListItem = (listItemToCreate) => {
        const newListItems = [listItemToCreate, ...listItems];
        setListItems(newListItems);
        notifyItemsAdded();
    }

    const createListItems = (listItemsToCreate) => {
        const newListItems = [...listItemsToCreate, ...listItems];
        setListItems(newListItems);
        notifyItemsAdded();
    }

    const updateListItem = (listItemToUpdate) => {
        const newListItems = [...listItems];
        const existingItemIndex = newListItems.findIndex(listItem => listItem.product_id === listItemToUpdate.product_id);
        let existingItemToMutate = {...newListItems[existingItemIndex]};
        existingItemToMutate.quantity += 1;
        newListItems[existingItemIndex] = existingItemToMutate;
        setListItems(newListItems);

        notifyItemUpdated();
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

    const toggleLoading = (loadingState) => {
        setIsLoading(loadingState);
    }
/*
    const listItemsToRender = listItems.map(item => <ListItem
                    key={item.id}
                    listId={listId}
                    listItem={item}
                    products={products}
                    getListItems={getListItems}
                    hideCompletedListItems={hideCompletedListItems}
                    handleErrors={handleErrors}
                    clearErrors={clearErrors}
                />
        );*/




    return (
        <>
            {errorMessage && (
                <ErrorMessage errorMessage={errorMessage}/>
            )}
            {!isLoading && (
                <>
                    <ImageUpload
                        createListItems={createListItems}
                        listId={listId}
                        handleErrors={handleErrors}
                        clearErrors={clearErrors}
                        products={products}
                        notifyNoItemsMatched={notifyNoItemsMatched}
                    />
                    <ProductSearchPanel
                        createListItem={createListItem}
                        updateListItem={updateListItem}
                        listId={listId}
                        handleErrors={handleErrors}
                        clearErrors={clearErrors}
                        products={products}
                    />
                    <ListItems
                        toggleCompletedListItems={toggleCompletedListItems}
                        hideCompletedListItems={hideCompletedListItems}
                    >
                        {listItems.map(item =>
                                <ListItem
                                    key={item.id}
                                    listId={listId}
                                    listItem={item}
                                    products={products}
                                    getListItems={getListItems}
                                    updateListItem={updateListItem}
                                    hideCompletedListItems={hideCompletedListItems}
                                    handleErrors={handleErrors}
                                    clearErrors={clearErrors}
                                />
                        )}
                    </ListItems>
                </>
            )}
            {isLoading && <Spinner/>}
            <ToastContainer
                position="bottom-right"
                autoClose={2000}
                hideProgressBar={true}
                closeOnClick
            />
        </>
    );
}

export default ListPanel;

document.addEventListener('turbolinks:load', () => {
    const app = document.getElementById('list-panel');
    app && ReactDOM.render(<ListPanel/>, app);
})
