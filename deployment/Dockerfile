FROM node:20-alpine AS build

ENV NODE_ENV=production \
    DAEMON=false \
    SILENT=false \
    USER=nodebb \
    UID=1001 \
    GID=1001

WORKDIR /usr/src/app/

# Install required packages and download NodeBB
RUN apk add --no-cache \
    tini \
    bash \
    python3 \
    make \
    g++ \
    git \
    && corepack enable

# Download NodeBB directly from GitHub
RUN git clone -b v3.12.7 https://github.com/NodeBB/NodeBB.git . \
    && rm -rf .git

# Create non-root user
RUN addgroup -g ${GID} -S ${USER} \
    && adduser -u ${UID} -S ${USER} -G ${USER} -h /usr/src/app -s /bin/bash \
    && chown -R ${USER}:${USER} /usr/src/app

USER ${USER}

# Prepare package.json and install dependencies
RUN cp /usr/src/app/install/package.json /usr/src/app/package.json \
    && npm install --omit=dev --no-fund --no-audit \
    && npm cache clean --force

FROM node:20-alpine AS final

ENV NODE_ENV=production \
    DAEMON=false \
    SILENT=false \
    USER=nodebb \
    UID=1001 \
    GID=1001

WORKDIR /usr/src/app/

# Install runtime dependencies
RUN apk add --no-cache \
    tini \
    bash \
    wget \
    && corepack enable \
    && addgroup -g ${GID} -S ${USER} \
    && adduser -u ${UID} -S ${USER} -G ${USER} -h /usr/src/app -s /bin/bash \
    && mkdir -p /usr/src/app/logs/ /opt/config/ \
    && chown -R ${USER}:${USER} /usr/src/app/ /opt/config/

# Copy application and setup files
COPY --from=build --chown=${USER}:${USER} /usr/src/app/ /usr/src/app/

# Copy custom entrypoint script
COPY --chown=${USER}:${USER} deployment/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER ${USER}

EXPOSE 4567

VOLUME ["/usr/src/app/node_modules", "/usr/src/app/build", "/usr/src/app/public/uploads", "/opt/config/"]

# Health check for better deployment monitoring
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:4567/api || exit 1

ENTRYPOINT ["tini", "--", "entrypoint.sh"]
