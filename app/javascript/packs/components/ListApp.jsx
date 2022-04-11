import React, {useState, useEffect} from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';

import Lists from "./Lists";
import List from "./List";
import ListForm from "./ListForm";
import Spinner from "./Spinner";
import ErrorMessage from "./ErrorMessage"

const ListApp = () => {
    const [lists, setLists] = useState([]);
    const [hideCompletedLists, setHideCompletedLists] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [errorMessage, setErrorMessage] = useState(null);

    useEffect(() => {
        getLists();
    }, [])

    const getLists = () => {
        axios.get("/api/v1/lists")
            .then(response => {
                clearErrors();
                setIsLoading(true);
                const lists = response.data;
                setLists(lists);
                setIsLoading(false);
            })
            .catch(error => {
                setIsLoading(true);
                setErrorMessage({message: "There was an error loading your lists..."});
            });
    }

    const createList = (list) => {
        const newLists = [list, ...lists];
        setLists(newLists);
    }

    const toggleCompletedLists = () => {
        console.log('toggling completed lists');
        setHideCompletedLists(!hideCompletedLists);
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
                    <ListForm
                        createList={createList}
                        handleErrors={handleErrors}
                        clearErrors={clearErrors}/>
                    <Lists
                        toggleCompletedLists={toggleCompletedLists}
                        hideCompletedLists={hideCompletedLists}>
                        {lists.map(list => (
                            <List
                                key={list.id}
                                list={list}
                                getLists={getLists}
                                hideCompletedLists={hideCompletedLists}
                                handleErrors={handleErrors}
                                clearErrors={clearErrors}
                            />
                        ))}
                    </Lists>
                </>
            )}
            {isLoading && <Spinner />}
        </>
    );
}

document.addEventListener('turbolinks:load', () => {
    const app = document.getElementById('list-app');
    app && ReactDOM.render(<ListApp/>, app);
})