import React, {useState} from 'react';
import PropTypes from 'prop-types';
import {QRCodeSVG} from 'qrcode.react';
import Modal from 'react-modal';

Modal.setAppElement('#list-panel-root');

const QrModal = ({modalIsOpen, closeModal , qrJson}) => {
    console.log(qrJson);
    return (
        <>
            <Modal isOpen={modalIsOpen} onRequestClose={closeModal} contentLabel="QR Code Modal">
                <QRCodeSVG value={qrJson} includeMargin={true} />
                <button className="btn btn-outline-primary mx-1">print</button>
                <button onClick={closeModal} className="btn btn-outline-secondary mx-1">close</button>
            </Modal>
        </>
    )
}

export default QrModal

QrModal.propTypes = {
    qrJson: PropTypes.string.isRequired,
    modalIsOpen: PropTypes.bool.isRequired,
    closeModal: PropTypes.func.isRequired,
}