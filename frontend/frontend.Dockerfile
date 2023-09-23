# syntax=docker/dockerfile:1

FROM debian:stable-slim
ARG ENABLE_PRESETS
ARG ENABLE_PROMPT

# Install flutter dependencies
RUN apt-get update
RUN apt-get install -y curl git python3 unzip
RUN apt-get clean

# Setup flutter
RUN git clone --depth 1 -b 3.10.6 https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="${PATH}:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin"
RUN flutter doctor

# Copy over flutter app and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter clean
RUN flutter build web --dart-define="ENABLE_PRESETS=${ENABLE_PRESETS}" --dart-define="ENABLE_PROMPT=${ENABLE_PROMPT}" --web-renderer html

# Serve assets
WORKDIR /app/build/web
EXPOSE 8080
CMD python3 -m http.server 8080
