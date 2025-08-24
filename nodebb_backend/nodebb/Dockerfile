FROM node:18-alpine

WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Create uploads directory
RUN mkdir -p /usr/src/app/public/uploads

# Expose port
EXPOSE 4567

# Start the application
CMD ["npm", "start"]
