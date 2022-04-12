import React, {useState, useEffect} from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';

import { ListItems, ListItem, ListItemForm, Spinner, ErrorMessage } from "./";

const ListPanel = () => {
    const [listItems, setListItems] = useState([]);
    const [hideCompletedListItems, setHideCompletedListItems] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [errorMessage, setErrorMessage] = useState(null);
    const listId = window.location.pathname.split('/')[2];
    const path = `/api/v1/lists/${listId}/list_items`

    useEffect(() => {
        getListItems();
    }, [])

    const getListItems = () => {
        axios.get(path)
            .then(response => {
                clearErrors();
                setIsLoading(true);
                const retrievedListItems = response.data;
                console.log(retrievedListItems);
                setListItems(retrievedListItems);
                setIsLoading(false);
            })
            .catch(error => {
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
                    <ListItemForm
                        createListItem={createListItem}
                        listId={listId}
                        handleErrors={handleErrors}
                        clearErrors={clearErrors}/>
                    <ListItems
                        toggleCompletedListItems={toggleCompletedListItems}
                        hideCompletedListItems={hideCompletedListItems}>
                        {listItems.map(item => (
                            <ListItem
                                key={item.id}
                                listId={listId}
                                listItem={item}
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
