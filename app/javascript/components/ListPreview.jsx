import React, {useState, useRef} from 'react'
import PropTypes from 'prop-types'
import axios from "axios";
import _ from "lodash";

import setAxiosHeaders from "./AxiosHeaders";

const ListPreview = ({list, getLists, hideCompletedLists, handleErrors, clearErrors}) => {
    const [complete, setComplete] = useState(list.complete);
    const [published, setPublished] = useState(list.published);
    const completedRef = useRef();
    const publishedRef = useRef();
    const inputRef = useRef();
    const path = `/api/v1/lists/${list.id}`
    console.log(list);

    const handleChange = () => {
        setComplete(completedRef.current.checked);
        setPublished(publishedRef.current.checked);
        updateList();
    }

    const updateList = _.debounce(() => {
        setAxiosHeaders();
        axios
            .put(path, {
                list: {
                    title: inputRef.current.value,
                    complete: completedRef.current.checked,
                    published: publishedRef.current.checked
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
                <div className="form-check form-check-inline">
                    <input
                        type="boolean"
                        defaultChecked={published}
                        type="checkbox"
                        onChange={handleChange}
                        ref={publishedRef}
                        className="form-check-input"
                        id={`published-${list.id}`}
                    />
                    <label
                        className="form-check-label"
                        htmlFor={`published-${list.id}`}
                    >
                        Published?
                    </label>
                </div>
                <a href={`/lists/${list.id}`} className="btn btn-outline-primary mx-1">Edit</a>
                <button onClick={handleDestroy} className="btn btn-outline-danger mx-1">Delete</button>
            </td>
        </tr>
    )
}

export default ListPreview

ListPreview.propTypes = {
    list: PropTypes.object.isRequired,
    getLists: PropTypes.func.isRequired,
    hideCompletedLists: PropTypes.bool.isRequired,
    handleErrors: PropTypes.func.isRequired,
    clearErrors: PropTypes.func.isRequired,
}