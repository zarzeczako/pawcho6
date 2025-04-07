# Etap 1: Backend
FROM node:alpine AS backend

# Ustawienie katalogu roboczego
WORKDIR /usr/app

# Instalacja curl oraz OpenSSH (potrzebne do używania SSH)
RUN apk add --no-cache curl openssh

# Skopiowanie pliku package.json i instalacja zależności
COPY package.json ./ 
RUN npm install

# Skopiowanie pliku aplikacji
COPY index.js ./

# Otwieramy port 8081
EXPOSE 8081

# Uruchomienie aplikacji backend (Express)
CMD ["node", "index.js"]

# Etap 2: Budowanie aplikacji frontend (Nginx)
FROM nginx:alpine AS frontend

# Instalacja git i openssh
RUN apk add --no-cache openssh git

# Skopiowanie pliku konfiguracyjnego Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Skopiowanie klucza SSH do kontenera
COPY id_ed25519 /root/.ssh/id_ed25519

# Ustawienie odpowiednich uprawnień do klucza SSH
RUN chmod 600 /root/.ssh/id_ed25519

# Dodanie github.com do listy zaufanych hostów SSH
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Skopiowanie repozytorium z GitHub za pomocą SSH
RUN git clone git@github.com:zarzeczako/pawcho6.git /usr/app


# Skopiowanie zawartości repozytorium do kontenera
COPY . /usr/app

# Otwieramy port 80
EXPOSE 80

# Uruchomienie Nginx
CMD ["nginx", "-g", "daemon off;"]
