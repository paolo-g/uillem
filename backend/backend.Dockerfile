# syntax=docker/dockerfile:1

FROM golang:1.19-alpine
ARG MODEL_FILENAME
ARG MODEL_HOST_URL
ARG THREAD_LIMIT

RUN set -ex; \
    apk update; \
    apk add build-base curl git cmake openblas-dev

WORKDIR /
COPY . .

# Build api
RUN GOOS=linux go build -o /usr/local/bin/uillem .

# Build llama.cpp
RUN git clone --depth 1 -b b4404 https://github.com/ggerganov/llama.cpp.git
WORKDIR /llama.cpp
RUN cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS
RUN cmake --build build --config Release

# Download the model
WORKDIR /llama.cpp/models
RUN curl -L "${MODEL_HOST_URL}" -o "${MODEL_FILENAME}"

# Start api
WORKDIR /llama.cpp
EXPOSE 8088
CMD ["uillem"]
