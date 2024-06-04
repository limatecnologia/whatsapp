const { Client, LocalAuth, MessageMedia } = require('whatsapp-web.js');
const express = require('express');
const multer = require('multer');
const moment = require('moment-timezone');

const app = express();
const port = 4040;

const client = new Client({
    authStrategy: new LocalAuth(),
    puppeteer: { args: ['--no-sandbox'] }
});

client.initialize();

client.on('loading_screen', (percent, message) => {
    console.log('Carregando', percent, message);
});

client.on('authenticated', () => {
    console.log('Autenticado');
});

client.on('auth_failure', msg => {
    console.error('Falha na autenticacao', msg);
});

client.on('ready', () => {
    console.log('Cliente iniciado e pronto para uso!');
});

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Funções auxiliares
const isGroup = (number) => number.toString().startsWith('55') && (number.toString().length === 12 || number.toString().length === 13);

const getCurrentTime = () => moment().tz('America/Sao_Paulo').format('DD-MM-YYYY HH:mm:ss');

// Enviar mensagem - POST
app.post('/api/message', (req, res) => {
    const { number, message } = req.body;
    const chatId = isGroup(number) ? `${number}@g.us` : `${number}@c.us`;

    client.sendMessage(chatId, message)
        .then(() => {
            console.log(`${getCurrentTime()} - Mensagem enviada com sucesso para: ${number}`);
            res.json({ message: 'Mensagem enviada com sucesso' });
        })
        .catch((error) => {
            console.error(`${getCurrentTime()} - Erro ao enviar mensagem para: ${number}`);
            console.error('Erro:', error);
            res.status(500).json({ error: 'Erro ao enviar mensagem' });
        });
});

// Enviar mensagem - GET
app.get('/api/message', (req, res) => {
    const { number, message } = req.query;
    const chatId = isGroup(number) ? `${number}@g.us` : `${number}@c.us`;

    client.sendMessage(chatId, message)
        .then(() => {
            console.log(`${getCurrentTime()} - Mensagem enviada com sucesso para: ${number}`);
            res.json({ message: 'Mensagem enviada com sucesso' });
        })
        .catch((error) => {
            console.error(`${getCurrentTime()} - Erro ao enviar mensagem para: ${number}`);
            console.error('Erro:', error);
            res.status(500).json({ error: 'Erro ao enviar mensagem' });
        });
});

// Enviar arquivos
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadDirectory = req.body.destination || 'uploads/';
        cb(null, uploadDirectory);
    },
    filename: (req, file, cb) => {
        cb(null, file.originalname);
    }
});

const upload = multer({ storage });

app.post('/api/download', upload.single('file'), async (req, res) => {
    try {
        const { number, filepath, caption, destination } = req.body;
        const uploadDirectory = destination || 'uploads/';
        const media = MessageMedia.fromFilePath(`${uploadDirectory}${filepath}`);
        const chatId = isGroup(number) ? `${number}@g.us` : `${number}@c.us`;

        await client.sendMessage(chatId, media, { caption });

        console.log(`${getCurrentTime()} - Arquivo enviado com sucesso para: ${number}`);
        res.json({ message: `Arquivo enviado com sucesso para: ${chatId}` });
    } catch (error) {
        console.error(`${getCurrentTime()} - Erro ao enviar o arquivo:`, error);
        res.status(500).send('Erro ao enviar o arquivo');
    }
});

// Inicia o servidor
app.listen(port, () => {
    console.log(`Servidor está rodando em http://localhost:${port}`);
});
