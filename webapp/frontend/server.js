'use strict';

const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const API_URL = process.env.API_URL || 'http://api.app.localhost';

app.use(express.static(path.join(__dirname, 'public')));

app.get('/config.json', (_req, res) => {
  res.json({ apiUrl: API_URL });
});

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'frontend' });
});

app.listen(PORT, () => {
  console.log(`Frontend running on port ${PORT}`);
});
