# Etap 1: Backend z Node.js
FROM node:bullseye AS backend

# Ustawienie katalogu roboczego
WORKDIR /usr/app

# Instalacja curl
RUN apt-get update && apt-get install -y curl

# Kopiowanie pliku package.json i instalacja zależności
COPY package.json ./
RUN npm install

# Kopiowanie pliku aplikacji
COPY index.js ./

# Otwieramy port 8081 dla aplikacji backendowej
EXPOSE 8081

# Healthcheck dla aplikacji backendowej
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:8081/health || exit 1

# Uruchomienie aplikacji backendowej (Express)
CMD ["node", "index.js"]

# Etap 2: Frontend z Nginx
FROM nginx:alpine AS frontend

# Skopiowanie plików statycznych frontendowych
COPY ./frontend /usr/share/nginx/html

# Otwieramy port 80 dla Nginx
EXPOSE 80

# Healthcheck dla Nginx
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost/ || exit 1

# Uruchomienie Nginx
CMD ["nginx", "-g", "daemon off;"]
