### What we have so far

1. [Ollama](https://github.com/ollama/ollama) loads and serves a few models via API. 
    - Ollama itself doesn't have a UI. CLI and API only.
    - The API can be accessed at [`https://api.ollama.jafner.net`](https://api.ollama.jafner.net).
    - Ollama running as configured supports ROCm (GPU acceleration).
    - Configured models are described [here](/ollama/modelfiles/), and 
    - Run Ollama with: `HSA_OVERRIDE_GFX_VERSION=11.0.0 OLLAMA_HOST=192.168.1.135:11434 OLLAMA_ORIGINS="app://obsidian.md*" OLLAMA_MAX_LOADED_MODELS=0 ollama serve`
2. [Open-webui](https://github.com/open-webui/open-webui) provides a pretty web interface for interacting with Ollama. 
    - The web UI can be accessed at [`https://ollama.jafner.net`](https://ollama.jafner.net).
    - The web UI is protected by Traefik's `lan-only` rule, as well as its own authentication layer.
    - Run open-webui with: `cd ~/Projects/LLMs/open-webui && docker compose up -d && docker compose logs -f`
        - Then open [the page](https://ollama.jafner.net) and log in.
        - Connect the frontend to the ollama instance by opening the settings (top-right), clicking "Connections", and setting "Ollama Base URL" to "https://api.ollama.jafner.net". Hit refresh and begin using.
3. [SillyTavern](https://github.com/SillyTavern/SillyTavern) provides a powerful interface for building and using characters.
    - Run SillyTavern with: `cd ~/Projects/LLMs/SillyTavern && ./start.sh`
4. [Oobabooga](https://github.com/oobabooga/text-generation-webui) provides a more powerful web UI than open-webui, but it's less pretty. 
    - Run Oobabooga with: `cd ~/Projects/LLMs/text-generation-webui && ./start_linux.sh`
    - Requires the following environment variables be set in `one_click.py` (right after import statements):
```
os.environ["ROCM_PATH"] = '/opt/rocm'
os.environ["HSA_OVERRIDE_GFX_VERSION"] = '11.0.0'
os.environ["HCC_AMDGPU_TARGET"] = 'gfx1100'
os.environ["PATH"] = '/opt/rocm/bin:$PATH'
os.environ["LD_LIBRARY_PATH"] = '/opt/rocm/lib:$LD_LIBRARY_PATH'
os.environ["CUDA_VISIBLE_DEVICES"] = '0'
os.environ["HCC_SERIALIZE_KERNEL"] = '0x3'
os.environ["HCC_SERIALIZE_KERNEL"]='0x3'
os.environ["HCC_SERIALIZE_COPY"]='0x3'
os.environ["HIP_TRACE_API"]='0x2' 
os.environ["HF_TOKEN"]='<my-huggingface-token>'
```
    - Requires the following environment variable be set in `start_linux.sh` for access to non-public model downloads:
```
# config
HF_TOKEN="<my-huggingface-token>"
```

That's where we're at. 

### Set Up Models Directory
1. Navigate to the source directory with all models: `cd "~/Nextcloud/Large Language Models/GGUF/"`
2. Symlink each file into the docker project's models directory: `for model in ./*; do ln $(realpath $model) $(realpath ~/Git/docker-llm-amd/models/$model); done`
   - Note that the symlinks must be hardlinks or they will not be passed properly into containers.
3. Launch ollama: `docker compose up -d ollama`
4. Create models defined by the modelfiles: `docker compose exec -dit ollama /modelfiles/.loadmodels.sh`

### Roadmap
- Set up StableDiffusion-web-UI.
- Get characters in SillyTavern behaving as expected.
    - Repetition issues.
    - Obsession with certain parts of prompt.
    - Refusals.
- Set up something for character voices. 
    - [Coqui TTS - Docker install](https://github.com/coqui-ai/TTS/tree/dev?tab=readme-ov-file#docker-image).
    - [TTS Generation Web UI](https://github.com/rsxdalv/tts-generation-webui).

- Set up Extras for SillyTavern.

### Notes
- So many of these projects use Python with its various version and dependencies and shit. 
    - *Always* use a Docker container or virtual environment.
    - It's like a condom.