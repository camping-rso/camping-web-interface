### STAGE 1: Build ###
FROM node:12.7-alpine AS build
WORKDIR /usr/src/app
COPY code/Avtokampi-Web/package.json code/Avtokampi-Web/package-lock.json ./
RUN npm install
COPY code/Avtokampi-Web/ .
ARG BASE_PATH="camping-web-interface"
RUN npm run build -- --prod --base-href="/$BASE_PATH" --deploy-url="$BASE_PATH/"

### STAGE 2: Run ###
FROM nginx:1.17.1-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/src/app/dist/Avtokampi-Web /usr/share/nginx/html

# When the container starts, replace the env.js with values from environment variables
CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]