import React, {useState, useEffect} from 'react';
import PropTypes from 'prop-types';
import axios from "axios";

import {getWordsFromImage, matchWordsFromImageProductIds} from "../utils/imageIngestUtils";
import {setAxiosHeaders, Spinner} from "./";


const ImageUpload = ({createListItems, listId, handleErrors, clearErrors, products, notifyNoItemsMatched}) => {
    const [image, setImage] = useState("");
    const [url, setUrl] = useState("");
    const [isLoading, setIsLoading] = useState(false);

    const processImage = () => {
        setIsLoading(true);
        const data = new FormData();
        data.append("file", image);
        data.append("upload_preset", "listApp");
        data.append("cloud_name", "dtk99iksj");

        fetch("  https://api.cloudinary.com/v1_1/dtk99iksj/image/upload", {
            method: "post",
            body: data
        })
            .then(response => {
                return response.json();
            })
            .then(data => {
                setUrl(data.url);
            })
            .catch(err => console.log(err));
    }

    const addProductsFromImage = async (url) => {
        const wordsFromImage = await getWordsFromImage(url);
        const listItemsToCreate = [];
        const matchedProductIds = matchWordsFromImageProductIds(wordsFromImage, products);
        if (matchedProductIds.length === 0) {
            setIsLoading(false);
            notifyNoItemsMatched();
            return;
        }

        const postAllMatchedProducts = () => {
            return Promise.all(matchedProductIds.map(matchedProductId => {
                setAxiosHeaders();
                return axios
                    .post(`/api/v1/lists/${listId}/list_items`, {
                        list_item: {
                            product_id: matchedProductId,
                            quantity: 1,
                        },
                    })
                    .then(response => {
                        const listItem = response.data;
                        listItemsToCreate.push(listItem);
                    })
                    .catch(error => {
                        console.log(error);
                        handleErrors(error);
                    })
            }))
        }

        let success = await postAllMatchedProducts();
        if (success) {
            setIsLoading(false);
            createListItems(listItemsToCreate);
            clearErrors();
        }
    }

    useEffect(() => {
        if (url) {
            addProductsFromImage(url);
        }
    }, [url])

    return (
        <div>
            <label>Add items to your list from an image:</label>
            <input type="file" className="form-control" onChange={(e) => setImage(e.target.files[0])}/>
            {image && <button className="btn btn-outline-primary my-2" onClick={processImage}>Add items from
                image</button>}
            {isLoading && <Spinner/>}
        </div>
    )
}

export default ImageUpload

ImageUpload.propTypes = {
    createListItems: PropTypes.func.isRequired,
    handleErrors: PropTypes.func.isRequired,
    clearErrors: PropTypes.func.isRequired,
    listId: PropTypes.string.isRequired,
    products: PropTypes.array.isRequired,
    notifyNoItemsMatched: PropTypes.func.isRequired,
}
