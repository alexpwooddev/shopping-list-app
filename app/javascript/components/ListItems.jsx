import React from 'react';
import PropTypes from 'prop-types';

const Lists = ({toggleCompletedListItems, hideCompletedListItems, ...props}) => {
    const handleClick = () => {
        toggleCompletedListItems();
    }

    return (
        <>
            <button
                className="btn btn-outline-primary btn-block mt-4"
                onClick={handleClick}>
                {hideCompletedListItems ? 'Show Completed Items' : 'Hide Completed Items'}
            </button>
            <div className="table-responsive">
                <table className="table">
                    <thead>
                    <tr>
                        <th scope="col">Item</th>
                        <th scope="col">Quantity</th>
                        <th scope="col" className="text-right">
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
    toggleCompletedListItems: PropTypes.func.isRequired,
    hideCompletedListItems: PropTypes.bool.isRequired,
}