Markdown
# 🛰️ AstroCode: Autonomous Agentic Workflows
**High-Performance AI Agents Accelerated by AMD ROCm & vLLM**

![AstroCode Cover](https://via.placeholder.com/1280x720?text=AstroCode+AMD+Hackathon) ## 🚀 Vision
AstroCode is a next-generation AI Assistant platform designed to bridge the gap between high-performance hardware and autonomous execution. By leveraging the **AMD Instinct™ MI300X** ecosystem and **vLLM**, AstroCode delivers lightning-fast agentic reasoning, allowing for complex multi-step workflows to be executed with minimal latency.

## 🛠️ Tech Stack
- **AI Core:** AMD ROCm™ 7.0, vLLM, Hugging Face
- **Models:** Qwen 2.5-7B, Llama 3.2
- **Backend:** Node.js, Express
- **Database:** MySQL 8.0, Sequelize ORM
- **Frontend:** EJS, Tailwind CSS (Futuristic Dark Glassmorphism)

## ✨ Key Features
- **AMD Hardware Acceleration:** Optimized for ROCm stacks to ensure maximum throughput for Large Language Models.
- **Agentic Persistence:** Unlike standard stateless bots, AstroCode uses a MySQL backend to maintain long-term memory and task states.
- **Futuristic Interface:** A sleek, glassmorphic dashboard providing real-time telemetry of agent actions.
- **Autonomous Planning:** Capable of breaking down complex prompts into executable sub-tasks.

## 📁 Project Structure
```text
astrocode/
├── config/          # Database & AI configurations
├── models/          # Sequelize schemas (Agents, Tasks)
├── views/           # EJS templates (UI Dashboard)
├── app.js           # Core server & logic
├── .env             # Environment variables
└── package.json     # Dependencies
🚀 Quick Start
1. Prerequisites
Node.js (v18+)

MySQL (Server running)

AMD ROCm / vLLM (For AI features)

2. Installation
Bash
# Clone the repository
git clone [https://github.com/yourusername/astrocode.git](https://github.com/yourusername/astrocode.git)
cd astrocode

# Install dependencies
npm install
3. Database Setup
Create a MySQL database named astro_code and execute the provided schema.sql.

4. Configure Environment
Create a .env file in the root directory:

Cuplikan kode
DB_NAME=astro_code
DB_USER=root
DB_PASS=your_password
DB_HOST=127.0.0.1
PORT=3000
5. Launch
Bash
npm start
Visit http://localhost:3000 to interact with your agent.

🏆 Hackathon Focus: The AMD Edge
AstroCode is specifically engineered to demonstrate the power of AMD’s open-source software stack. By utilizing vLLM on ROCm, we achieve a significant increase in tokens per second (TPS) compared to non-optimized backends, enabling a more responsive and "intelligent" feeling for autonomous agents.

👤 Author
Habi Utomo Full-stack Developer | CEO PT Cloud System Indonesia

© 2026 AstroCode Team - Built for the AMD Developer Hackathon.