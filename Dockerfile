# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install --production

# Copy app source code
COPY . .

# Expose the application port
EXPOSE 80

# Start the application
CMD ["node", "app.js"]
