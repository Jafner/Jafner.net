# Flash Attention in Docker on AMD is Not Yet Working
Below are my notes on the efforts I've made to get it working.

```Dockerfile
FROM rocm/pytorch-nightly:latest
COPY . .
RUN git clone --recursive https://github.com/ROCm/flash-attention.git /tmp/flash-attention
WORKDIR /tmp/flash-attention
ENV MAX_JOBS=8
RUN pip install -v .
```

# Resources
1. [What is Flash-attention? (How do i use it with Oobabooga?) :...](https://www.reddit.com/r/Oobabooga/comments/193mcv0/what_is_flashattention_how_do_i_use_it_with/)
2. [Adding flash attention to one click installer · Issue #4015 ...](https://github.com/oobabooga/text-generation-webui/issues/4015)
3. [Accelerating Large Language Models with Flash Attention on A...](https://rocm.blogs.amd.com/artificial-intelligence/flash-attention/README.html)
4. [GitHub - Dao-AILab/flash-attention: Fast and memory-efficien...](https://github.com/Dao-AILab/flash-attention)
5. [GitHub - ROCm/llvm-project: This is the AMD-maintained fork ...](https://github.com/ROCm/llvm-project)
6. [GitHub - ROCm/AITemplate: AITemplate is a Python framework w...](https://github.com/ROCm/AITemplate)
7. [Stable diffusion with RX7900XTX on ROCm5.7 · ROCm/composable...](https://github.com/ROCm/composable_kernel/discussions/1032#522-build-ait-and-stable-diffusion-demo)
8. [Current state of training on AMD Radeon 7900 XTX (with bench...](https://www.reddit.com/r/LocalLLaMA/comments/1atvxu2/current_state_of_training_on_amd_radeon_7900_xtx/) [[Current state of training on AMD Radeon 7900 XTX (with benchmarks)  rLocalLLaMA]]
9. [llm-tracker - howto/AMD GPUs](https://llm-tracker.info/howto/AMD-GPUs)
10. [RDNA3 support · Issue #27 · ROCm/flash-attention · GitHub](https://github.com/ROCm/flash-attention/issues/27)
11. [GitHub - ROCm/xformers: Hackable and optimized Transformers ...](https://github.com/ROCm/xformers/tree/develop)
12. [\[ROCm\] support Radeon™ 7900 series (gfx1100) without using...](https://github.com/vllm-project/vllm/pull/2768)