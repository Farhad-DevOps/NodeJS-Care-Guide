# ---------- Stage 1: Build / Dependencies ----------
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package*.json ./
RUN npm ci --only=production

# Copy application source
COPY src ./src

# ---------- Stage 2: Minimal runtime image ----------
FROM node:20-alpine AS runtime

# Create a non-root user & group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy only the built artifacts and node_modules from builder
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/src ./src
COPY --from=builder --chown=appuser:appgroup /app/package.json ./package.json

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 3000

# Use exec form for proper signal handling
CMD ["node", "src/index.js"]
