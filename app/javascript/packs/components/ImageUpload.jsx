import React, {useState, useEffect} from 'react';

const getWordsFromImage = (url) => {
    const apiKey = process.env.COMPUTER_VISION_API_KEY;
    const computerVisionApiOptions = {
        method: 'POST',
        headers: {
            'content-type': 'application/json',
            'X-RapidAPI-Host': 'microsoft-computer-vision3.p.rapidapi.com',
            'X-RapidAPI-Key': `${apiKey}`
        },
        body: `{"url":"${url}"}`
    };
    let responseWords = [];

    fetch('https://microsoft-computer-vision3.p.rapidapi.com/ocr?detectOrientation=true&language=unk', computerVisionApiOptions)
        .then(response => response.json())
        .then(response => {
            response?.regions?.forEach(region => {
                region.lines.forEach(line => {
                    line.words.forEach(word => {
                        responseWords.push(word.text);
                    })
                })
            });
        })
        .catch(err => console.error(err));

    return responseWords;
}


const ImageUpload = () => {
    const [image, setImage] = useState("");
    const [url, setUrl] = useState("");

    const processImage = () => {
        const data = new FormData()
        data.append("file", image)
        data.append("upload_preset", "listApp")
        data.append("cloud_name", "dtk99iksj")

        fetch("  https://api.cloudinary.com/v1_1/dtk99iksj/image/upload", {
            method: "post",
            body: data
        })
            .then(resp => resp.json())
            .then(data => {
                setUrl(data.url)
            })
            .catch(err => console.log(err))
    }

    useEffect(() => {
        let wordsFromImage;
        if (url) {
            wordsFromImage = getWordsFromImage(url);
        }
        console.log(wordsFromImage);
    }, [url])

    return (
        <div>
            <p>Add items to your list from an image:</p>
            <div>
                <input type="file" className="form-control" onChange={(e) => setImage(e.target.files[0])}/>
                {image && <button className="btn btn-outline-primary my-2" onClick={processImage}>Add items from
                    image</button>}
            </div>
        </div>
    )
}

export default ImageUpload
