import React from 'react';

const Spinner = () => {
    return (
        <div className="d-flex align-items-center justify-content-center">
            <div className="spinner-border text-success" role="status">
                <span className="visually-hidden">loading...</span>
            </div>
        </div>
    );
};

export default Spinner;