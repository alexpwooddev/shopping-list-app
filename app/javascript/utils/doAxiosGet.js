import axios from "axios";

export const doAxiosGetProducts = (path, clearErrors, setIsLoading, setProducts, setErrorMessage) => {
    axios.get(path)
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

export const doAxiosGetListItems = (path, clearErrors, setIsLoading, setListItems, setIsValidList, setErrorMessage) => {
    axios.get(path)
        .then(response => {
            clearErrors();
            setIsLoading(true);
            const retrievedListItems = response.data;
            setListItems(retrievedListItems);
            setIsLoading(false);
        })
        .catch(error => {
            console.log(error);
            setIsValidList(false);
            setErrorMessage({message: "There was an error loading that list or it doesn't exist"});
        });
}