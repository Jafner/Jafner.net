# Ollama Notes
Per: [Ollama/Ollama README](https://github.com/ollama/ollama)

## Install Steps
Per: [linux.md](https://github.com/ollama/ollama/blob/main/docs/linux.md)

1. Download the binary: `sudo curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/bin/ollama`
2. Make the binary executable: `sudo chmod +x /usr/bin/ollama`
3. Create a user for ollama: `sudo useradd -r -s /bin/false -m -d /usr/share/ollama ollama`
4. Create a SystemD service file for ollama: `sudo nano /etc/systemd/system/ollama.service` and populate it with the following.
```ini
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
Environment='HSA_OVERRIDE_GFX_VERSION=11.0.0 OLLAMA_HOST=192.168.1.135:11434 OLLAMA_ORIGINS="app://obsidian.md*" OLLAMA_MAX_LOADED_MODELS=0'
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
```
5. Register and enable the ollama service: `sudo systemctl daemon-reload && sudo systemctl enable ollama`
6. Start ollama: `sudo systemctl start ollama`

### Enable ROCm Support
Per: [anvesh.jhuboo on Medium](https://medium.com/@anvesh.jhuboo/rocm-pytorch-on-fedora-51224563e5be)

1. Add user to `video` group to allow access to GPU resources: `sudo usermod -aG video $LOGNAME`
2. Install `rocminfo` package: `sudo dnf install rocminfo`
3. Check for rocm support: `rocminfo`
4. Install `rocm-opencl` package: `sudo dnf install rocm-opencl`
5. Install `rocm-clinfo` package: `sudo dnf install rocm-clinfo`
6. Verify opencl is working: `rocm-clinfo`
7. Get the GFX version of your GPU: `rocminfo | grep gfx | head -n 1 | tr -s ' ' | cut -d' ' -f 3`
    - The GFX version given is a stripped version number. 
    - My Radeon 7900 XTX has a gfx string of `gfx1100`, which correlates with HSA GFX version 11.0.0. 
    - Other cards commonly have a string of `gfx1030`, which correlates with HSA GFS version 10.3.0.
    - There's a little bit more info [here](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html).
8. Export your gfx version in `~/.bashrc`: `echo "export HSA_OVERRIDE_GFX_VERSION=11.0.0" >> ~/.bashrc && source ~/.bashrc`

- Is this even part of the same thing? I ran `sudo dnf install https://repo.radeon.com/amdgpu-install/6.0.2/rhel/9.3/amdgpu-install-6.0.60002-1.el9.noarch.rpm`
- Maybe this is the right place to look? [Fedora wiki - AMD ROCm](https://fedoraproject.org/wiki/SIGs/HC)

## Run Ollama
1. Test Ollama is working: `ollama run gemma:2b`
    - Runs (downloads) the smallest model in [Ollama's library](https://ollama.com/library). 
2. Run as a docker container: `docker run -d --device /dev/kfd --device /dev/dri -v /usr/lib64:/opt/lib64:ro -e HIP_PATH=/opt/lib64/rocm -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama && docker logs -f ollama`


## Update Ollama
1. Redownload the binary: `sudo curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/bin/ollama`
2. Make the binary executable: `sudo chmod +x /usr/bin/ollama`

## Create Model from Modelfile

`ollama create <model name> -f <modelfile relative path>`
Where the modelfile is like:
```
# Choose either a model tag to download from ollama.com/library, or a path to a local model file (relative to the path of the modelfile).
FROM ../Models/codellama-7b.Q8_0.gguf

# set the chatml template passed to the model
TEMPLATE """<|im_start|>system
{{ .System }}<|im_end|>
<|im_start|>user
{{ .Prompt }}<|im_end|>
<|im_start|>assistant
"""

# set the temperature to 1 [higher is more creative, lower is more coherent]
PARAMETER temperature 1

# set the system message
SYSTEM """
You are a senior devops engineer, acting as an assistant. You offer help with cloud technologies like: Terraform, AWS, kubernetes, python. You answer with code examples when possible
"""

# not sure what this does lol
PARAMETER stop "<|im_start|>"
PARAMETER stop "<|im_end|>"
```

## Unload a Model
There's no official support for this in the `ollama` CLI, but we can make it happen with the API:
`curl https://api.ollama.jafner.net/api/generate -d '{"model": "<MODEL TO UNLOAD>", "keep_alive": 0}'`