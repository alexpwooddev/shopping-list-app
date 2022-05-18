import React, {useRef} from 'react';
import PropTypes from 'prop-types';
import Modal from 'react-modal';
import {useReactToPrint} from "react-to-print";
import {QrCodeToPrint} from "./";

const customStyles = {
    content: {
        width: '50%',
        height: '50%',
        top: '25%',
        left: '25%',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
    },
};

Modal.setAppElement('#root');

const QrModal = ({modalIsOpen, closeModal, qrJson}) => {
    const qrToPrintRef = useRef();
    const handlePrint = useReactToPrint({
        content: () => qrToPrintRef.current,
    });

    return (
        <>
            <Modal isOpen={modalIsOpen} onRequestClose={closeModal} contentLabel="QR Code Modal" style={customStyles}>
                <QrCodeToPrint qrJson={qrJson} ref={qrToPrintRef}/>
                <button onClick={handlePrint} className="btn btn-outline-primary mx-1">print</button>
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