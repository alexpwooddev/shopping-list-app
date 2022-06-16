import axios from "axios";

export const doAxiosPost = (path, productId, createItem, updateItem, clearErrors, handleErrors ) => {
    axios
        .post( path, {
            list_item: {
                product_id: productId,
                quantity: 1,
            },
        })
        .then(response => {
            if (response.status === 201) {
                const listItem = response.data;
                createItem(listItem);
            } else if (response.status === 200) {
                const updatedListItem = response.data
                updateItem(updatedListItem);
            }
            clearErrors();
        })
        .catch(error => {
            handleErrors(error);
        })
}

