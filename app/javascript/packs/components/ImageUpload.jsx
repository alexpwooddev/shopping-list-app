import React, { useState } from 'react';
import PropTypes from 'prop-types';

const ImageUpload = () => {
    const [image, setImage ] = useState("");
    const [ url, setUrl ] = useState("");
    const uploadImage = () => {
        const data = new FormData()
        data.append("file", image)
        data.append("upload_preset", "listApp")
        data.append("cloud_name","dtk99iksj")
        fetch("  https://api.cloudinary.com/v1_1/dtk99iksj/image/upload",{
            method:"post",
            body: data
        })
            .then(resp => resp.json())
            .then(data => {
                setUrl(data.url)
            })
            .catch(err => console.log(err))
    }
    return (
        <div>
            <p>Add items to your list from an image:</p>
            <div>
                <input type="file" className="form-control" onChange= {(e)=> setImage(e.target.files[0])}></input>
                <button className="btn btn-outline-primary my-2" onClick={uploadImage}>Upload</button>
                <button className="btn btn-outline-primary my-2 ms-1" >Add image items</button>
            </div>
        </div>
    )
}

export default ImageUpload

ImageUpload.propTypes = {

}