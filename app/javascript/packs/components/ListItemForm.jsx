import React, { useRef } from 'react'
import PropTypes from 'prop-types'
import axios from 'axios'

import setAxiosHeaders from "./AxiosHeaders";


const ListItemForm = ({ createListItem, listId, handleErrors, clearErrors }) => {
    const handleSubmit = (e) => {
        e.preventDefault();
        setAxiosHeaders();
        //TO DO - update this to have a drop down to select a product OR a search
        axios
            .post(`/api/v1/lists/${listId}/list_items`, {
                list_item: {
                    product_id: 1,
                    quantity: 1,
                },
            })
            .then(response => {
                const listItem = response.data;
                createListItem(listItem);
                clearErrors();
            })
            .catch(error => {
                handleErrors(error);
            })
        e.target.reset();
    }

    return (
        <form onSubmit={handleSubmit} className={"my-3"}>
            <div className={"form-row"}>
                <div className="form-group col-md-4">
                    <button className="btn btn-outline-success btn-block">
                        Add New Item
                    </button>
                </div>
            </div>
        </form>
    )
}

export default ListItemForm

ListItemForm.propTypes = {
    createListItem: PropTypes.func.isRequired,
    handleErrors: PropTypes.func.isRequired,
    clearErrors: PropTypes.func.isRequired,
    listId: PropTypes.string.isRequired,
}

