# Cloned from: https://github.com/Atinoda/text-generation-webui-docker/blob/master/Dockerfile
# Modified to install Flash-Attention-2 for AMD ROCm.
# Install instructions for FA2 are based on:
# https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/3rd-party/pytorch-install.html#using-pytorch-upstream-docker-image
# and:
# https://rocm.blogs.amd.com/artificial-intelligence/flash-attention/README.html
# Also trimmed original comments and replaced with new.

# Base build layer
FROM ubuntu:22.04 AS app_base
RUN apt-get update && apt-get install --no-install-recommends -y \
    git vim build-essential python3-dev python3-venv python3-pip
RUN pip3 install virtualenv
RUN virtualenv /venv
ENV VIRTUAL_ENV=/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install --upgrade pip setuptools
COPY ./scripts /scripts
RUN chmod +x /scripts/*
RUN git clone https://github.com/oobabooga/text-generation-webui /src
ARG VERSION_TAG
ENV VERSION_TAG=${VERSION_TAG}
RUN . /scripts/checkout_src_version.sh
RUN cp -ar /src /app

# AMD build layer
FROM app_base AS app_rocm
RUN pip3 install --pre torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/nightly/rocm6.1
RUN pip3 install -r /app/requirements_amd.txt
RUN git clone --recursive https://github.com/ROCm/flash-attention.git /src-fa
RUN cd /src-fa && MAX_JOBS=$((`nproc` / 2)) pip install -v .
FROM app_rocm AS app_rocm_x
RUN chmod +x /scripts/build_extensions.sh && \
    . /scripts/build_extensions.sh

# Base run layer
FROM ubuntu:22.04 AS run_base
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-venv python3-dev git
COPY --from=app_base /app /app
COPY --from=app_base /src /src
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
WORKDIR /app
EXPOSE 7860
EXPOSE 5000
EXPOSE 5005
ENV PYTHONUNBUFFERED=1
ARG BUILD_DATE
ENV BUILD_DATE=$BUILD_DATE
RUN echo "$BUILD_DATE" > /build_date.txt
ARG VERSION_TAG
ENV VERSION_TAG=$VERSION_TAG
RUN echo "$VERSION_TAG" > /version_tag.txt
COPY ./scripts /scripts
RUN chmod +x /scripts/*
ENTRYPOINT ["/scripts/docker-entrypoint.sh"]

# AMD run layer
FROM run_base AS default-rocm
COPY --from=app_rocm_x $VIRTUAL_ENV $VIRTUAL_ENV
RUN echo "ROCM Extended" > /variant.txt
ENV EXTRA_LAUNCH_ARGS=""
CMD ["python3", "/app/server.py"]