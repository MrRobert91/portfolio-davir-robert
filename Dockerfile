# Build stage
FROM klakegg/hugo:ext-alpine AS builder
WORKDIR /src
COPY . .
RUN hugo --minify --baseURL "/"

# Serve stage
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets from builder stage
COPY --from=builder /src/public .
# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
