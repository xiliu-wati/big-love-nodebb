#!/usr/bin/env bash
set -euo pipefail

# Enhanced startup script with better error handling and configuration
echo "🚀 Starting NodeBB deployment..."

# Environment variable setup with defaults
PORT_VAL="${PORT:-4567}"
URL_VAL="${URL:-${RAILWAY_STATIC_URL:-http://localhost:${PORT_VAL}}}"
SECRET_VAL="${NODEBB_SECRET:-$(openssl rand -hex 32)}"

# Database configuration - supports both PostgreSQL and Redis
if [[ "${DATABASE_URL:-}" != "" ]]; then
    echo "📊 Configuring PostgreSQL database..."
    # Extract database info from DATABASE_URL if provided
    DB_HOST="${PGHOST:-$(echo $DATABASE_URL | sed 's|.*@\([^:]*\):.*|\1|')}"
    DB_PORT="${PGPORT:-$(echo $DATABASE_URL | sed 's|.*:\([0-9]*\)/.*|\1|')}"
    DB_USER="${PGUSER:-$(echo $DATABASE_URL | sed 's|.*://\([^:]*\):.*|\1|')}"
    DB_PASS="${PGPASSWORD:-$(echo $DATABASE_URL | sed 's|.*://[^:]*:\([^@]*\)@.*|\1|')}"
    DB_NAME="${PGDATABASE:-$(echo $DATABASE_URL | sed 's|.*/\([^?]*\).*|\1|')}"
    
    DATABASE_TYPE="postgres"
elif [[ "${REDIS_URL:-}" != "" ]]; then
    echo "📊 Configuring Redis database..."
    DATABASE_TYPE="redis"
else
    echo "⚠️  No database configuration found, using default PostgreSQL settings"
    DB_HOST="${PGHOST:-postgres}"
    DB_PORT="${PGPORT:-5432}"
    DB_USER="${PGUSER:-nodebb}"
    DB_PASS="${PGPASSWORD:-nodebb}"
    DB_NAME="${PGDATABASE:-nodebb}"
    DATABASE_TYPE="postgres"
fi

# Create config directory
mkdir -p /opt/config

# Generate configuration file
if [[ "$DATABASE_TYPE" == "postgres" ]]; then
    cat > /opt/config/config.json <<JSON
{
  "url": "${URL_VAL}",
  "secret": "${SECRET_VAL}",
  "database": "postgres",
  "postgres": {
    "host": "${DB_HOST}",
    "port": ${DB_PORT},
    "username": "${DB_USER}",
    "password": "${DB_PASS}",
    "database": "${DB_NAME}",
    "ssl": {
      "rejectUnauthorized": false
    }
  },
  "port": ${PORT_VAL},
  "bind_address": "0.0.0.0",
  "logLevel": "${LOG_LEVEL:-info}",
  "daemon": false,
  "session_store": {
    "name": "connect-pg-simple"
  }
}
JSON
else
    cat > /opt/config/config.json <<JSON
{
  "url": "${URL_VAL}",
  "secret": "${SECRET_VAL}",
  "database": "redis",
  "redis": {
    "url": "${REDIS_URL}"
  },
  "port": ${PORT_VAL},
  "bind_address": "0.0.0.0",
  "logLevel": "${LOG_LEVEL:-info}",
  "daemon": false
}
JSON
fi

echo "✅ Generated configuration:"
cat /opt/config/config.json

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
if [[ "$DATABASE_TYPE" == "postgres" ]]; then
    until pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}"; do
        echo "Waiting for PostgreSQL to be ready..."
        sleep 2
    done
else
    # For Redis, try to connect using Node.js since redis-cli isn't available
    node -e "
        const redis = require('ioredis');
        const client = new redis(process.env.REDIS_URL);
        client.ping()
          .then(() => { console.log('Redis is ready!'); process.exit(0); })
          .catch(() => { console.log('Redis not ready, retrying...'); process.exit(1); });
    " || sleep 5
fi

echo "🗄️ Database is ready!"

# Setup NodeBB if first time
if [[ ! -f "/opt/config/.setup_complete" ]]; then
    echo "🔧 Setting up NodeBB for the first time..."
    ./nodebb setup --skip
    echo "setup_complete" > "/opt/config/.setup_complete"
    echo "✅ NodeBB setup complete!"
fi

# Build assets if needed
echo "🔨 Building NodeBB assets..."
./nodebb build

echo "🎉 Starting NodeBB application..."
exec node app.js


