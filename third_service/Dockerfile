# Use the official Node image with the specified Node version.
FROM node:18.14.2

# Set working directory
WORKDIR /app

# Copy package files and install dependencies.
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code.
COPY . .

# Expose the port the app runs on.
EXPOSE 3002

# Start the React app.
CMD ["npm", "start"]
