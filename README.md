# Uillem

An offline, containerized LLM interface. Builds with an optional search interface and preset educational prompts. Plug in any model. No GPU required.

## Requirements

- Docker for Desktop (https://www.docker.com/products/docker-desktop/)
- Docker configured to share sufficient RAM for your selected model (10GB seems to work for the stock build), and `THREAD_LIMIT` CPU cores

## Building

Download and build the containers with:

```
docker compose build
```

This could take awhile to complete depending on your PC and internet connection, as it downloads 5GB. Maybe turn off your monitor and go for a walk.

Once complete, you might want to restart Docker Desktop to free up RAM. After Docker starts back up, you can launch the app with:

```
docker compose up
```

Now, open your browser and point it to: `http://localhost:8080`

You can also directly query the backend with: `http://localhost:8088/prompt?p=...`

## Optional configuration

The `/.env` file contains configuration options for the LLM model used and UI features.

### Selected model

The build comes with a stock 7B LLM, but you can plug in any model supported by llama.cpp (https://github.com/ggerganov/llama.cpp) using these env vars:

`MODEL_HOST_URL` is the download path that curl uses to download the model.

`MODEL_FILENAME` must be set to the filename of the model downloaded from `MODEL_HOST_URL`.

It's simple to modify the `curl` command in `/backend/backend.Dockerfile` if you need add flags to support IPFS, etc.

### Processor resources

By default, the configuration uses 5 CPU threads.

`THREAD_LIMIT` can be adjusted if your CPU has more/fewer cores shareable in Docker

### User Interface

Set `ENABLE_PRESETS` to `false` to hide the preset prompts.

Set `ENABLE_PROMPT` to `false` to hide the input prompt.

## License and Usage

This software is being made freely available under the MIT license and I take no responsibility for your use of it. Stay safe and do the right thing.
