FROM rocm/pytorch:latest
WORKDIR /dockerx
RUN git clone https://github.com/lshqqytiger/stable-diffusion-webui-amdgpu 
WORKDIR /dockerx/stable-diffusion-webui-amdgpu
RUN python -m pip install clip open-clip-torch onnxruntime-training xformers
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-assets.git repositories/stable-diffusion-webui-assets
RUN git clone https://github.com/Stability-AI/stablediffusion.git repositories/stable-diffusion-stability-ai
RUN git clone https://github.com/Stability-AI/generative-models.git repositories/generative-models
RUN git clone https://github.com/crowsonkb/k-diffusion.git repositories/k-diffusion
RUN git clone https://github.com/salesforce/BLIP.git repositories/BLIP

RUN python -m pip install --upgrade pip wheel
ENV REQS_FILE='requirements_versions.txt'
ENV venv_dir="-"
RUN python -m pip install -r requirements_versions.txt
ENV COMMANDLINE_ARGS="--listen --allow-code --api --administrator --no-download-sd-model --medvram --use-directml"
CMD ["python", "-u", "launch.py", "--precision", "full", "--no-half"]