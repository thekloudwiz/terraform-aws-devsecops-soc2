# Stage 1: Build the application
FROM node:24-slim AS builder

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install npm-force-resolutions --save-dev

# Copy the rest of the application code
COPY . .

# Stage 2: Run the application
FROM node:23-alpine

# Set the working directory
WORKDIR /usr/src/app

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only the necessary files from the builder stage
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/src ./src
COPY --from=builder /usr/src/app/public ./public
COPY --from=builder /usr/src/app/package*.json ./

# Change ownership of the working directory to the non-root user
RUN chown -R appuser:appgroup /usr/src/app

# Switch to the non-root user
USER appuser

# Expose port 3000
EXPOSE 3000

# Run the application
CMD ["node", "src/app.js"]