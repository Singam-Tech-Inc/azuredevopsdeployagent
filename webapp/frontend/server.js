'use strict';

const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const API_URL = process.env.API_URL || 'http://api.app.localhost';
const APP_VERSION = process.env.APP_VERSION || 'unknown';

app.use((_req, res, next) => {
  res.set('X-App-Version', APP_VERSION);
  next();
});

app.use(express.static(path.join(__dirname, 'public')));

app.get('/config.json', (_req, res) => {
  res.json({ apiUrl: API_URL });
});

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'frontend', version: APP_VERSION });
});

app.get('/version', (_req, res) => {
  res.json({ version: APP_VERSION });
});

app.listen(PORT, () => {
  console.log(`Frontend running on port ${PORT}`);
});
