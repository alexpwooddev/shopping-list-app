export const getWordsFromImage = async (url) => {
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

    await fetch('https://microsoft-computer-vision3.p.rapidapi.com/ocr?detectOrientation=true&language=unk', computerVisionApiOptions)
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

export const matchWordsFromImageProductIds = (wordsFromImage, products) => {
    const productNames = products.map(product => product.name);
    const productsMatchedAgainstWordsFromImage = [];

    wordsFromImage?.forEach(word => {
        if (productNames.includes(word)) productsMatchedAgainstWordsFromImage.push(word);
    });

    return productsMatchedAgainstWordsFromImage.map(matchedProduct => {
        let matchedId;
        products.forEach(product => {
            if (product.name === matchedProduct) {
                matchedId = product.id;
            }
        });
        return matchedId;
    });
}