'use strict';

const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 5000;
const API_URL = process.env.API_URL || 'http://api.app.localhost';

app.use(express.static(path.join(__dirname, 'public')));

app.get('/config.json', (_req, res) => {
  res.json({ apiUrl: API_URL });
});

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'dashboard' });
});

app.listen(PORT, () => {
  console.log(`Dashboard running on port ${PORT}`);
});
