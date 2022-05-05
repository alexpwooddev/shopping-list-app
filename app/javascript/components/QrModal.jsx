import React, {useState} from 'react';
import PropTypes from 'prop-types';
import {QRCodeSVG} from 'qrcode.react';
import Modal from 'react-modal';

Modal.setAppElement('#list-panel');

const QrModal = ({json}) => {
    const [modalIsOpen, setIsOpen] = useState(false);

    const openModal


    return (
        <>
            <QRCodeSVG value={json}/>
        </>
    )
}

export default QrModal

QrModal.propTypes = {
    json: PropTypes.string.isRequired,
}