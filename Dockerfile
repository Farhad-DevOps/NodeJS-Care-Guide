# ---------- Stage 1: Build / Dependencies ----------
FROM node:20-alpine AS builder
WORKDIR /app

# Copy manifests first for layer caching
COPY package*.json ./
RUN npm ci --only=production

# Copy application source
COPY src ./src

# ---------- Stage 2: Minimal runtime image ----------
FROM node:20-alpine AS runtime

# Create non-root user & group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy only built artifacts from builder
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/src ./src
COPY --from=builder --chown=appuser:appgroup /app/package.json ./package.json

# Switch to non-root user
USER appuser

EXPOSE 3000

CMD ["node", "src/index.js"]
