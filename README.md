# Uillem

An offline, containerized LLM interface. Plug in any llama.cpp supported model. Builds with optional search and preset educational prompts.

## Requirements

- Docker for Desktop (https://www.docker.com/products/docker-desktop/)
- Docker configured to share sufficient RAM for your selected model (10GB for the stock build)
- Docker configured to share `THREAD_LIMIT` number of CPU cores (5 used on test machine)

## Build and run

Download and build the containers with:

```
docker compose build
```

This could take a long while to complete depending on your selected model and internet connection (stock build downloads ~5GB). Maybe turn off your monitor and go for a walk.

Once the build is complete, start the containers with:

```
docker compose up
```

Now, open your browser and point it to: `http://localhost:8080`

You can also directly query the backend with: `http://localhost:8088/prompt?p=...`

## Configuration

The `/.env` file contains configuration options.

### Model

The build comes with a stock 7B LLM, but you can plug in any model supported by llama.cpp (https://github.com/ggerganov/llama.cpp) using the `MODEL_HOST_URL` env var.

`MODEL_HOST_URL` is the download path that curl uses to download the model you select.

`MODEL_FILENAME` is used as an internal file reference.

### Resources

By default, the configuration uses 5 threads. The number of threads and the CPU performance will affect how long results take to generate.

`THREAD_LIMIT` should be set to match the number of CPU cores shared in Docker

### Features

Set `ENABLE_PRESETS` to `false` to hide the preset prompts.

Set `ENABLE_PROMPT` to `false` to hide the input prompt.

## License and Usage

This software is being made freely available under the MIT license and I take no responsibility for your use of it. Stay safe and do the right thing.
