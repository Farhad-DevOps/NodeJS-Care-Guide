const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Root endpoint — required by task
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Hello from DevOps Intern Task!',
    status: 'running',
  });
});

// Health-check endpoint for orchestrators
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;
