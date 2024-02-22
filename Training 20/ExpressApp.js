const express = require('express');
const axios = require('axios');

const app = express();
const port = 3000;

// Route to check latest transactions of a specific address
app.get('/transactions/:address', async (req, res) => {
    try {
        const address = req.params.address;
        const response = await axios.get(`https://sepolia.arbiscan.io/tx/${address}&page=1&offset=10&sort=desc`);
        res.json(response.data);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
