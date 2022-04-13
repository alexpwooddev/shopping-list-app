import React, { useRef } from 'react'
import PropTypes from 'prop-types'
import axios from 'axios'

import setAxiosHeaders from "./AxiosHeaders";


const ListForm = ({ createList, handleErrors, clearErrors }) => {
    const titleRef = useRef();

    const handleSubmit = (e) => {
        e.preventDefault();
        setAxiosHeaders();
        axios
            .post('/api/v1/lists', {
                list: {
                    title: titleRef.current.value,
                    complete: false,
                },
            })
            .then(response => {
                const list = response.data;
                createList(list);
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
                <div className="form-group col-md-8">
                    <input
                    type="text"
                    name="title"
                    ref={titleRef}
                    required
                    className="form-control"
                    id="title"
                    placeholder="Write your list here..."
                    />
                </div>
                <div className="form-group col-md-4">
                    <button className="btn btn-outline-success btn-block mt-2">
                        Add New List
                    </button>
                </div>
            </div>
        </form>
    )
}

export default ListForm

ListForm.propTypes = {
    createList: PropTypes.func.isRequired,
    handleErrors: PropTypes.func.isRequired,
    clearErrors: PropTypes.func.isRequired,
}

