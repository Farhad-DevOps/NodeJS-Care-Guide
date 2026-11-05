const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Health endpoint
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Hello from DevOps Intern Task!',
    status: 'running',
  });
});

// Health check endpoint for Kubernetes / load balancers
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;
