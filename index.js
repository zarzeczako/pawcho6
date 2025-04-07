const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 8081;  // Zmienione z 8080 na 8081

app.get('/', (req, res) => {
  const response = `
    <h1>Serwer działa!</h1>
    <p>Adres IP: ${req.socket.localAddress}</p>
    <p>Nazwa hosta: ${os.hostname()}</p>
    <p>Wersja aplikacji: ${process.env.VERSION || '1.0.0'}</p>
  `;
  res.send(response);
});


app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});
