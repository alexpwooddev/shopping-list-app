import React, {useState, useEffect} from 'react';
import PropTypes from 'prop-types';

import {getWordsFromImage} from "../utils/getWordsFromImage";
import {setAxiosHeaders} from "./index";
import axios from "axios";


const ImageUpload = ({createListItems, listId, handleErrors, clearErrors, products}) => {
    const [image, setImage] = useState("");
    const [url, setUrl] = useState("");
    const productNames = products.map(product => product.name);

    const processImage = () => {
        const data = new FormData()
        data.append("file", image)
        data.append("upload_preset", "listApp")
        data.append("cloud_name", "dtk99iksj")

        fetch("  https://api.cloudinary.com/v1_1/dtk99iksj/image/upload", {
            method: "post",
            body: data
        })
            .then(resp => resp.json())
            .then(data => {
                setUrl(data.url)
            })
            .catch(err => console.log(err))
    }

    const matchImageWordsWithProducts = async (url) => {
        const wordsFromImage = await getWordsFromImage(url);
        const productsMatchedAgainstWordsFromImage = [];
        const listItemsToCreate = [];
        wordsFromImage?.forEach(word => {
            if (productNames.includes(word)) productsMatchedAgainstWordsFromImage.push(word);
        });
        console.log(productsMatchedAgainstWordsFromImage);

        const matchedProductIds = productsMatchedAgainstWordsFromImage.map(matchedProduct => {
           let matchedId;
            products.forEach(product => {
               if (product.name === matchedProduct) {
                   matchedId = product.id;
               }
           });
            return matchedId;
        });

 /*       matchedProductIds.forEach(matchedProductId => {
            setAxiosHeaders();
            axios
                .post(`/api/v1/lists/${listId}/list_items`, {
                    list_item: {
                        product_id: matchedProductId,
                        quantity: 1,
                    },
                })
                .then(response => {
                    const listItem = response.data;
                    listItemsToCreate.push(listItem);
                    clearErrors();
                })
                .catch(error => {
                    handleErrors(error);
                })
        });*/

        await Promise.all(matchedProductIds.map(matchedProductId => {
            setAxiosHeaders();
            axios
                .post(`/api/v1/lists/${listId}/list_items`, {
                    list_item: {
                        product_id: matchedProductId,
                        quantity: 1,
                    },
                })
                .then(response => {
                    const listItem = response.data;
                    listItemsToCreate.push(listItem);
                    console.log(`pushed ${listItem} to array: ${listItemsToCreate}`);
                    clearErrors();
                })
                .catch(error => {
                    handleErrors(error);
                })
        }))
        //this is running before those axios posts hit their .then block and push the returned item
        createListItems(listItemsToCreate);
    }

    useEffect(() => {
        if (url) {
            matchImageWordsWithProducts(url);
        }
    }, [url])

    return (
        <div>
            <p>Add items to your list from an image:</p>
            <div>
                <input type="file" className="form-control" onChange={(e) => setImage(e.target.files[0])}/>
                {image && <button className="btn btn-outline-primary my-2" onClick={processImage}>Add items from
                    image</button>}
            </div>
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
}
