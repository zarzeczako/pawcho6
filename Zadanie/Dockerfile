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

# Otwieramy port 8081
EXPOSE 8081

# Healthcheck dla aplikacji backendowej
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:8081/health || exit 1

# Uruchomienie aplikacji backend (Express)
CMD ["node", "index.js"]





# Etap 2: Budowanie aplikacji frontend (Nginx)
FROM nginx:alpine AS frontend

# Skopiowanie pliku konfiguracyjnego Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Otwieramy port 80
EXPOSE 80

# Healthcheck dla Nginx
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost/ || exit 1

# Uruchomienie Nginx (domyślnie Nginx działa na porcie 80)
CMD ["nginx", "-g", "daemon off;"]
