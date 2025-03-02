# Step 1: Use the official Node.js image as a base image
FROM node:18 AS build

# Step 2: Set the working directory
WORKDIR /app

#Clean and reinstall dependencies
#rm -rf node_modules package-lock.json
#npm cache clean --force

# Step 3: Copy only package.json and package-lock.json (this helps in caching dependencies)
COPY package*.json ./

# Step 4: Install dependencies (caching layer)
RUN npm install

# Step 5: Copy the rest of the app source code
COPY . .

# Step 6: Build the React app
RUN npm run build

# Step 7: Use a lighter image for serving the built app
FROM nginx:alpine

# Step 8: Copy the build files from the previous image into the nginx server
COPY --from=build /app/build /usr/share/nginx/html

# Step 9: Expose port 80 (nginx default port)
EXPOSE 80

# Step 10: Start nginx to serve the React app
CMD ["nginx", "-g", "daemon off;"]
