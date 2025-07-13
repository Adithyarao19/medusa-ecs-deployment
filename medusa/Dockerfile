# Use Node 18 - stable for Medusa
FROM node:18

# Set working directory inside the container
WORKDIR /app

# Copy everything from your local 'medusa' folder into the container
COPY . .

# Use only compatible npm version to avoid workspace errors
RUN npm install -g npm@10.2.3

# Install Medusa dependencies (skip workspace issues)
RUN npm install --legacy-peer-deps

# Expose Medusa backend port
EXPOSE 9000

# Start the Medusa backend server
CMD ["npm", "run", "start"]
