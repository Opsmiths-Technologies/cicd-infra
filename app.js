const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('Hello from CICD-Test-App v1! Image form ECR Yupi');
});

const PORT = 80;
app.listen(PORT, () => {
    console.log(`App running on port ${PORT}`);
});
