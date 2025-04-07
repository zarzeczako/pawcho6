# Etap 1: Backend
FROM node:alpine AS backend

WORKDIR /usr/app

# Instalacja curl oraz OpenSSH (potrzebne do używania SSH)
RUN apk add --no-cache curl openssh

# Skopiowanie pliku package.json i instalacja zależności
COPY package.json ./
RUN npm install

# Skopiowanie pliku aplikacji
COPY index.js ./

EXPOSE 8081

CMD ["node", "index.js"]


# Etap 2: Frontend (Nginx)
FROM nginx:alpine AS frontend

# Instalacja git i ssh
RUN apk add --no-cache openssh git

# Stworzenie folderu na klucz SSH
RUN mkdir -p /root/.ssh

# Skopiowanie prywatnego klucza SSH do kontenera
COPY id_ed25519 /root/.ssh/id_ed25519

# Ustawienie odpowiednich uprawnień
RUN chmod 600 /root/.ssh/id_ed25519

# Zaufanie do GitHuba
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Skopiowanie konfiguracji Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Sklonowanie repozytorium z GitHuba przez SSH
RUN git clone git@github.com:zarzeczako/pawcho6.git /usr/app

# Ustawienie katalogu roboczego
WORKDIR /usr/app

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
