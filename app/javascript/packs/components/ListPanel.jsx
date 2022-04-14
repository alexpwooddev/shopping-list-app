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

    const notifyItemsUpdate = () => toast.success("Item/s added");
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
        notifyItemsUpdate();
    }

    const createListItems = (listItemsToCreate) => {
        const newListItems = [...listItemsToCreate, ...listItems];
        setListItems(newListItems);
        notifyItemsUpdate();
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

    const listItemsToRender = () => {
        const itemsCount = {};
        const itemsAlreadyRendered = {};

        listItems.forEach(item => {
            itemsCount[item.product_id] = (itemsCount[item.product_id] || 0) + 1;
        })

        return listItems.map(item => {
            if (itemsAlreadyRendered[item.product_id]) {
                return;
            }
            else {
                itemsAlreadyRendered[item.product_id] = true;
                return <ListItem
                    key={item.id}
                    listId={listId}
                    listItem={item}
                    itemCount={itemsCount[item.product_id]}
                    products={products}
                    getListItems={getListItems}
                    hideCompletedListItems={hideCompletedListItems}
                    handleErrors={handleErrors}
                    clearErrors={clearErrors}
                />
            }
        });
    }



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
                        listId={listId}
                        handleErrors={handleErrors}
                        clearErrors={clearErrors}
                        products={products}
                    />
                    <ListItems
                        toggleCompletedListItems={toggleCompletedListItems}
                        hideCompletedListItems={hideCompletedListItems}>
                        {listItemsToRender()}
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
