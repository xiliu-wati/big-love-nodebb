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
    echo "📊 Configuring PostgreSQL database with DATABASE_URL..."
    echo "DATABASE_URL: ${DATABASE_URL}"
    
    # Use DATABASE_URL directly for NodeBB configuration
    DATABASE_TYPE="postgres"
    DB_CONNECTION_STRING="${DATABASE_URL}"
    
    # Extract individual components for connection testing (more robust parsing)
    DB_HOST=$(echo $DATABASE_URL | sed -n 's|.*@\([^:]*\):.*|\1|p')
    DB_PORT=$(echo $DATABASE_URL | sed -n 's|.*:\([0-9]*\)/.*|\1|p')
    DB_USER=$(echo $DATABASE_URL | sed -n 's|.*://\([^:]*\):.*|\1|p')
    DB_PASS=$(echo $DATABASE_URL | sed -n 's|.*://[^:]*:\([^@]*\)@.*|\1|p')
    DB_NAME=$(echo $DATABASE_URL | sed -n 's|.*/\([^?]*\).*|\1|p')
    
    echo "Parsed - Host: $DB_HOST, Port: $DB_PORT, User: $DB_USER, DB: $DB_NAME"
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
    if [[ "${DB_CONNECTION_STRING:-}" != "" ]]; then
        # Use DATABASE_URL directly
        cat > /opt/config/config.json <<JSON
{
  "url": "${URL_VAL}",
  "secret": "${SECRET_VAL}",
  "database": "postgres",
  "postgres": {
    "connectionString": "${DB_CONNECTION_STRING}",
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
        # Use individual connection parameters
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
    fi
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

# Wait for database to be ready (with timeout)
echo "⏳ Waiting for database to be ready..."
DB_READY=false
TIMEOUT=60  # 60 seconds timeout

if [[ "$DATABASE_TYPE" == "postgres" ]]; then
    echo "Testing PostgreSQL connection..."
    for i in $(seq 1 12); do  # 12 attempts, 5 seconds each = 60 seconds max
        if node -e "
            const { Client } = require('pg');
            const connectionString = '${DB_CONNECTION_STRING:-}';
            const client = new Client(connectionString ? connectionString : {
                host: '${DB_HOST}',
                port: ${DB_PORT},
                user: '${DB_USER}',
                password: '${DB_PASS}',
                database: '${DB_NAME}',
                ssl: { rejectUnauthorized: false }
            });
            client.connect()
                .then(() => { console.log('PostgreSQL is ready!'); client.end(); process.exit(0); })
                .catch(() => { process.exit(1); });
        " 2>/dev/null; then
            DB_READY=true
            break
        fi
        echo "Waiting for PostgreSQL to be ready... (attempt $i/12)"
        sleep 5
    done
else
    echo "Testing Redis connection..."
    for i in $(seq 1 12); do  # 12 attempts, 5 seconds each = 60 seconds max
        if node -e "
            const redis = require('ioredis');
            const client = new redis(process.env.REDIS_URL);
            client.ping()
              .then(() => { console.log('Redis is ready!'); process.exit(0); })
              .catch(() => { process.exit(1); });
        " 2>/dev/null; then
            DB_READY=true
            break
        fi
        echo "Waiting for Redis to be ready... (attempt $i/12)"
        sleep 5
    done
fi

if [[ "$DB_READY" == "true" ]]; then
    echo "🗄️ Database is ready!"
else
    echo "⚠️  Database connection timeout after ${TIMEOUT}s - continuing anyway..."
    echo "🚀 NodeBB will attempt to connect when it starts"
fi

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


