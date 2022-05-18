import {QRCodeSVG} from "qrcode.react";
import React from "react";

const QrCodeToPrint = React.forwardRef(({qrJson}, ref) => {
    return (
        <div ref={ref}>
            <QRCodeSVG value={qrJson} includeMargin={true} size={256} />
        </div>
    );
});

export default QrCodeToPrint;