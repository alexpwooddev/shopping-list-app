import React, {useState, useRef} from 'react'
import PropTypes from 'prop-types'
import axios from "axios";
import _ from "lodash";

import setAxiosHeaders from "./AxiosHeaders";

const List = ({list, getLists, hideCompletedLists, handleErrors, clearErrors}) => {
    const [complete, setComplete] = useState(list.complete);
    const completedRef = useRef();
    const inputRef = useRef();
    const path = `/api/v1/lists/${list.id}`

    const handleChange = () => {
        setComplete(completedRef.current.checked);
        updateList();
    }

    const updateList = _.debounce(() => {
        setAxiosHeaders();
        axios
            .put(path, {
                list: {
                    title: inputRef.current.value,
                    complete: completedRef.current.checked
                }
            })
            .then(response => {
                clearErrors();
            })
            .catch(error => {
                handleErrors(error);
            });
    }, 1000);

    const handleDestroy = () => {
        setAxiosHeaders();
        const confirmation = confirm("Are you sure?");
        if (confirmation) {
            axios
                .delete(path)
                .then(response => {
                    getLists();
                })
                .catch(error => {
                    console.log(error);
                })
        }
    }

    return (
        <tr className={`${ complete && hideCompletedLists ? `d-none` : "" } ${complete ? "table-light" : ""}`}>
            <td>
                <svg
                    className={`bi bi-check-circle ${
                        complete ? `text-success` : `text-muted`
                    }`}
                    width="2em"
                    height="2em"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <path
                        fillRule="evenodd"
                        d="M17.354 4.646a.5.5 0 010 .708l-7 7a.5.5 0 01-.708 0l-3-3a.5.5 0 11.708-.708L10 11.293l6.646-6.647a.5.5 0 01.708 0z"
                        clipRule="evenodd"
                    />
                    <path
                        fillRule="evenodd"
                        d="M10 4.5a5.5 5.5 0 105.5 5.5.5.5 0 011 0 6.5 6.5 0 11-3.25-5.63.5.5 0 11-.5.865A5.472 5.472 0 0010 4.5z"
                        clipRule="evenodd"
                    />
                </svg>
            </td>
            <td>
                <input
                    type="text"
                    defaultValue={list.title}
                    disabled={complete}
                    onChange={handleChange}
                    ref={inputRef}
                    className="form-control"
                    id={`list__title-${list.id}`}
                />
            </td>
            <td className="text-right">
                <div className="form-check form-check-inline">
                    <input
                        type="boolean"
                        defaultChecked={complete}
                        type="checkbox"
                        onChange={handleChange}
                        ref={completedRef}
                        className="form-check-input"
                        id={`complete-${list.id}`}
                    />
                    <label
                        className="form-check-label"
                        htmlFor={`complete-${list.id}`}
                    >
                        Complete?
                    </label>
                </div>
                <button onClick={handleDestroy} className="btn btn-outline-danger">Delete</button>
            </td>
        </tr>
    )
}

export default List

List.propTypes = {
    list: PropTypes.object.isRequired,
    getLists: PropTypes.func.isRequired,
    hideCompletedLists: PropTypes.bool.isRequired,
    handleErrors: PropTypes.func.isRequired,
    clearErrors: PropTypes.func.isRequired,
}