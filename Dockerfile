# ─────────────────────────────────────────────
#  SafePath – A* Navigation with delhi_graph.pkl
# ─────────────────────────────────────────────

# 1️⃣ Use a lightweight Python base
FROM python:3.11-slim

# 2️⃣ Set working directory
WORKDIR /app

# 3️⃣ Copy dependency list first (for Docker caching)
COPY requirements.txt .

# 4️⃣ Install system packages + dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libspatialindex-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 5️⃣ Copy app files (backend, graph, static assets)
COPY . .

# 6️⃣ Environment variables
ENV PYTHONUNBUFFERED=1 \
    PORT=8080 \
    OSMNX_CACHE=True

# 7️⃣ Expose the port Render / Cloud Run expects
EXPOSE 8080

# 8️⃣ Start using Gunicorn (for production)
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "4", "--timeout", "300"]
