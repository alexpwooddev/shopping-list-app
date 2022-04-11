import React from 'react';
import PropTypes from 'prop-types';

const Lists = ({toggleCompletedLists, hideCompletedLists, ...props}) => {
    const handleClick = () => {
        toggleCompletedLists();
    }

    return (
        <>
            <hr/>
            <button
                className="btn btn-outline-primary btn-block mb-3"
                onClick={handleClick}>
                {hideCompletedLists ? 'Show Completed Lists' : 'Hide Completed Lists'}
            </button>
            <div className="table-responsive">
                <table className="table">
                    <thead>
                    <tr>
                        <th scope="col">Status</th>
                        <th scope="col">Item</th>
                        <th scope="col" className="text-right">
                            Actions
                        </th>
                    </tr>
                    </thead>
                    <tbody>{props.children}</tbody>
                </table>
            </div>
        </>
    )
}

export default Lists

Lists.propTypes = {
    toggleCompletedLists: PropTypes.func.isRequired,
    hideCompletedLists: PropTypes.bool.isRequired,
}