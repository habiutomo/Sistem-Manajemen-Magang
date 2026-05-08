const express = require('express');
const { Sequelize, DataTypes } = require('sequelize');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();

// --- 1. CONFIGURATION & MIDDLEWARE ---
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// --- 2. DATABASE CONNECTION (Sequelize) ---
const sequelize = new Sequelize(
    process.env.DB_NAME || 'astro_code',
    process.env.DB_USER || 'root',
    process.env.DB_PASS || 'root',
    {
        host: process.env.DB_HOST || '127.0.0.1',
        dialect: 'mysql',
        logging: false,
    }
);

// --- 3. MODELS DEFINITION ---
const Agent = sequelize.define('Agent', {
    name: { type: DataTypes.STRING, allowNull: false },
    type: { type: DataTypes.STRING, defaultValue: 'AMD Optimizer' },
    status: { type: DataTypes.ENUM('Active', 'Idle', 'Maintenance'), defaultValue: 'Active' }
});

const Task = sequelize.define('Task', {
    title: { type: DataTypes.STRING, allowNull: false },
    payload: { type: DataTypes.TEXT },
    result: { type: DataTypes.TEXT },
    status: { 
        type: DataTypes.ENUM('Pending', 'Processing', 'Completed', 'Failed'), 
        defaultValue: 'Pending' 
    }
});

// Relationships
Agent.hasMany(Task);
Task.belongsTo(Agent);

// --- 4. AI SERVICE (AMD ROCm / vLLM Integration) ---
const callAIService = async (prompt) => {
    console.log(`[AMD ROCm Acceleration] Processing prompt: ${prompt}`);
    // Simulasi delay pemrosesan model AI (Qwen/Llama)
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve(`AstroCode System Response: Berhasil memproses instruksi "${prompt}" melalui akselerasi AMD vLLM. Optimasi selesai.`);
        }, 3000);
    });
};

// --- 5. ROUTES & CONTROLLERS ---

// Dashboard Route (Render index.ejs)
app.get('/', async (req, res) => {
    try {
        const agents = await Agent.findAll({ 
            include: [{ model: Task, limit: 5, order: [['createdAt', 'DESC']] }],
            order: [['createdAt', 'DESC']]
        });
        res.render('index', { agents });
    } catch (error) {
        res.status(500).send("Error rendering dashboard: " + error.message);
    }
});

// API: Create Task and Execute AI logic
app.post('/api/tasks', async (req, res) => {
    try {
        const { title, payload } = req.body;

        // Ambil agent pertama sebagai default (AstroBot-01)
        const agent = await Agent.findOne();
        
        if (!agent) return res.status(404).send("No Agent found.");

        // 1. Simpan Task ke Database dengan status Processing
        const task = await Task.create({ 
            title, 
            payload, 
            AgentId: agent.id, 
            status: 'Processing' 
        });
        
        // 2. Jalankan AI Service (Background Process)
        // Kita tidak menunggu (await) agar UI tidak 'hang', 
        // tapi dalam demo ini kita await agar hasil langsung muncul setelah refresh.
        const aiResult = await callAIService(payload);

        // 3. Update status Task setelah AI selesai
        await task.update({ 
            result: aiResult, 
            status: 'Completed' 
        });

        // Redirect kembali ke dashboard untuk melihat update
        res.redirect('/');
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// API: Get Agents Data (JSON)
app.get('/api/agents', async (req, res) => {
    const agents = await Agent.findAll({ include: [Task] });
    res.json(agents);
});

// --- 6. ERROR HANDLING ---
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke! Check terminal.');
});

// --- 7. SERVER STARTUP ---
const PORT = process.env.PORT || 3000;

const startAstroCode = async () => {
    try {
        // Autentikasi dan Sinkronisasi Database
        await sequelize.authenticate();
        await sequelize.sync({ force: false }); 
        console.log('✅ Connected to MySQL via Sequelize.');

        // Seed data jika tabel Agent masih kosong
        const count = await Agent.count();
        if (count === 0) {
            await Agent.create({ 
                name: 'AstroBot-Alpha', 
                type: 'AMD Agentic Core', 
                status: 'Active' 
            });
            console.log('🚀 Initialized AstroBot-Alpha.');
        }

        app.listen(PORT, () => {
            console.log(`
            --------------------------------------------------
            🛰️  ASTROCODE SERVER RUNNING ON PORT ${PORT}
            🔗  Local: http://localhost:${PORT}
            💻  Stack: Node.js, MySQL, AMD ROCm/vLLM
            --------------------------------------------------
            `);
        });
    } catch (error) {
        console.error('❌ Unable to start AstroCode:', error);
    }
};

startAstroCode();