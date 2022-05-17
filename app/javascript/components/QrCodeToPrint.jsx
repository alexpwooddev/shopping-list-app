import {QRCodeSVG} from "qrcode.react";
import React from "react";


export const QrCodeToPrint = React.forwardRef((props, ref) => {
    return (
        <QRCodeSVG ref={ref} value={qrJson} includeMargin={true} />
    );
});