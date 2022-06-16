import React, {useState, useEffect} from 'react';
import {doAxiosGetListItems, doAxiosGetProducts} from '../utils/doAxiosGet';
import {ToastContainer, toast} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

import {ListItems, ListItem, ProductSearchPanel, Spinner, ErrorMessage, ImageUpload} from './';

const ListPanel = () => {
    const [listItems, setListItems] = useState([]);
    const [products, setProducts] = useState([]);
    const [hideCompletedListItems, setHideCompletedListItems] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [isValidList, setIsValidList] = useState(true);
    const [errorMessage, setErrorMessage] = useState(null);
    const listId = window.location.pathname.split('/')[2];
    const listItemsPath = `/api/v1/lists/${listId}/list_items`;
    const productsPath = `/api/v1/products`;
    const notifySuccess = (message) => {
        return toast.success(message);
    }
    const notifyNoItemsMatched = () => toast.error("No valid products found in image")

    useEffect(() => {
        getListItems();
        getProducts();
    }, []);

    //TO DO  - refine this so I don't need to request ALL products from the API
    const getProducts = () => {
        doAxiosGetProducts(productsPath, clearErrors, setIsLoading, setProducts, setErrorMessage)
    }

    const getListItems = () => {
        doAxiosGetListItems(listItemsPath, clearErrors, setIsLoading, setListItems, setIsValidList, setErrorMessage)
    }

    const createListItem = (listItemToCreate) => {
        const newListItems = [listItemToCreate, ...listItems];
        setListItems(newListItems);
        notifySuccess("item added");
    }

    const createListItems = (listItemsToCreate) => {
        const updatedItems = [];
        // update existing items
        const newListItems = listItems.map(listItem => {
            const found = listItemsToCreate.find(itemToCreate => itemToCreate.product_id === listItem.product_id);
            if (found) {
                updatedItems.push(listItem);
                listItem = Object.assign(listItem, found);
            }
            return listItem;
        });

        // create any new items
        listItemsToCreate.forEach(itemToCreate => {
            const found = updatedItems.find(updatedItem => updatedItem.product_id === itemToCreate.product_id);
            if (!found) {
                newListItems.push(itemToCreate);
            }
        })
        setListItems(newListItems);

        notifySuccess(`${listItemsToCreate.length} items added`);
    }

    const updateListItem = (listItemToUpdate) => {
        setListItems(listItems.map(listItem => {
            if (listItem.product_id !== listItemToUpdate.product_id) return listItem
            return {...listItem, quantity: listItemToUpdate.quantity};
        }));

        notifySuccess("item updated");
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

    return (
        <>
            {errorMessage && (
                <ErrorMessage errorMessage={errorMessage}/>
            )}
            {!isLoading && isValidList && (
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
                                notifySuccess={notifySuccess}
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
