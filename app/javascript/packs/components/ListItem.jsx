import React, {useState, useRef} from 'react'
import PropTypes from 'prop-types'
import axios from "axios";
import _ from "lodash";
import "bootstrap-icons/font/bootstrap-icons.css";

import setAxiosHeaders from "./AxiosHeaders";

const ListItem = ({
                      listId,
                      listItem,
                      products,
                      getListItems,
                      updateListItem,
                      notifySuccess,
                      hideCompletedListItems,
                      handleErrors,
                      clearErrors
                  }) => {
    const [complete, setComplete] = useState(listItem.complete);
    const completedRef = useRef();
    const path = `/api/v1/lists/${listId}/list_items/${listItem.id}`
    const listItemProduct = products.filter(product => {
        return product.id === listItem.product_id;
    })?.[0];

    const handleCheckboxChange = () => {
        setComplete(completedRef.current.checked);
    }

    const handleDestroy = () => {
        setAxiosHeaders();
        const confirmation = confirm("Are you sure?");
        if (confirmation) {
            axios
                .delete(path)
                .then(response => {
                    notifySuccess("item removed");
                    getListItems();
                })
                .catch(error => {
                    console.log(error);
                })
        }
    }

    const handleQuantityChange = (changeType) => {
        const newQuantity = changeType === "increment" ? listItem.quantity + 1 : listItem.quantity - 1;

        if (newQuantity === 0) {
            handleDestroy();
        } else {
            setAxiosHeaders();
            axios
                .patch(path, {
                    list_item: {
                        product_id: listItem.product_id,
                        quantity: newQuantity,
                    },
                })
                .then(response => {
                    console.log(response);
                    const updatedListItem = response.data;
                    updateListItem(updatedListItem);
                    clearErrors();
                })
                .catch(error => {
                    handleErrors(error);
                })
        }

    }

    return (
        <tr className={`${complete && hideCompletedListItems ? `d-none` : ""} ${complete ? "table-light" : ""}`}>
            <td className="align-middle">{listItemProduct && listItemProduct.name}</td>
            <td className="align-middle">{listItem.quantity}</td>
            <td className="text-right">
                <div className="form-check form-check-inline">
                    <input
                        type="boolean"
                        defaultChecked={complete}
                        type="checkbox"
                        onChange={handleCheckboxChange}
                        ref={completedRef}
                        className="form-check-input"
                        id={`complete-${listItem.id}`}
                    />
                    <i className="bi bi-plus-circle mx-1" role="button" onClick={() => handleQuantityChange("increment")}/>
                    <i className="bi bi-dash-circle mx-1" role="button" onClick={() => handleQuantityChange("decrement")}/>
                </div>
                <button onClick={handleDestroy} className="btn btn-outline-danger">Delete</button>
            </td>
        </tr>
    )
}

export default ListItem

ListItem.propTypes = {
    listId: PropTypes.string.isRequired,
    listItem: PropTypes.object.isRequired,
    products: PropTypes.array.isRequired,
    getListItems: PropTypes.func.isRequired,
    updateListItem: PropTypes.func.isRequired,
    notifySuccess: PropTypes.func.isRequired,
    hideCompletedListItems: PropTypes.bool.isRequired,
    handleErrors: PropTypes.func.isRequired,
    clearErrors: PropTypes.func.isRequired,
}