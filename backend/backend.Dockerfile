# syntax=docker/dockerfile:1

FROM golang:1.19-alpine
ARG MODEL_FILENAME
ARG MODEL_HOST_URL

RUN set -ex; \
    apk update; \
    apk add build-base curl git make

WORKDIR /
COPY . .

# Build api
RUN GOOS=linux go build -o /usr/local/bin/uillem .

# Build llama.cpp
RUN git clone https://github.com/ggerganov/llama.cpp.git
WORKDIR /llama.cpp
RUN make

# Download the model
WORKDIR /llama.cpp/models
RUN curl -L "${MODEL_HOST_URL}" -o "${MODEL_FILENAME}"

# Start api
WORKDIR /llama.cpp
EXPOSE 8088
CMD ["uillem"]