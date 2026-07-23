# Stage 1: Build ứng dụng Angular bằng Node.js
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build -- --configuration=production

# Stage 2: Phục vụ ứng dụng bằng Nginx
FROM nginx:alpine

# Copy các file sau khi build từ Stage 1 sang thư mục chạy của Nginx
COPY --from=build /app/dist/angular-demo/browser /usr/share/nginx/html

# Copy file config Nginx tùy chỉnh vào container
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]