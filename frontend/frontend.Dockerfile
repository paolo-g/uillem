# syntax=docker/dockerfile:1

FROM debian:stable-slim
ARG ENABLE_PROMPT

# Install flutter dependencies
RUN apt-get update
RUN apt-get install -y curl git python3 unzip
RUN apt-get clean

# Setup flutter
RUN git clone -b 3.10.6 https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="${PATH}:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin"
RUN flutter doctor
RUN flutter channel master
RUN flutter upgrade

# Copy over flutter app and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web --dart-define="ENABLE_PROMPT=${ENABLE_PROMPT}"

# Download preset prompts
WORKDIR /app/build/web/assets
RUN curl -LO "https://pub-6936fbc2cd9842768dd645327529db88.r2.dev/presets.csv"

# Serve assets
WORKDIR /app/build/web
EXPOSE 8080
CMD python3 -m http.server 8080
