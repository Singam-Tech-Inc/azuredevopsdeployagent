'use strict';

const express = require('express');

const app = express();
const PORT = process.env.PORT || 4000;

app.use(express.json());

// Allow browser fetch from the frontend origin
app.use((_req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  next();
});

app.get('/', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'api',
    endpoints: ['/', '/health', '/api/items'],
  });
});

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'api', timestamp: new Date().toISOString() });
});

app.get('/api/items', (_req, res) => {
  res.json({
    items: [
      { id: 1, name: 'Azure DevOps Agent', status: 'running' },
      { id: 2, name: 'Traefik Proxy',      status: 'running' },
      { id: 3, name: 'Frontend',           status: 'running' },
      { id: 4, name: 'API',                status: 'running' },
    ],
  });
});

app.listen(PORT, () => {
  console.log(`API running on port ${PORT}`);
});
