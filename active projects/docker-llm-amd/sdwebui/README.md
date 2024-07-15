Below is a rough and dirty documentation of steps taken to set up stable-diffusion for my 7900 XTX. Sources cited as used. 
```
# Per: https://github.com/ROCm/composable_kernel/discussions/1032
# I did not read the bit where it said to execute these steps in a docker container (rocm/pytorch:rocm5.7_ubuntu22.04_py3.10_pytorch_2.0.1)
# The following is the docker run command I *would have* used:
docker run rocm/pytorch:rocm5.7_ubuntu22.04_py3.10_pytorch_2.0.1

git clone -b amd-stg-open https://github.com/RadeonOpenCompute/llvm-project.git # 
cd llvm-project && git checkout 1f2f539f7cab51623fad8c8a5b574eda1e81e0c0 && mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=1 -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" -DLLVM_ENABLE_PROJECTS="clang;lld;compiler-rt" ../llvm 
make -j16 # This step takes a long time. Reduce 16 to use fewer cores for the job.
# The build errored out at ~71% with:
# make: *** [Makefile:156: all] Error 2
# So that was a big waste of time.
# It was during this step that I realized we can just spin up the provided docker container to get the pre-compiled binary...

docker run aska0096/rocm5.7_ait_ck_navi31_sd2:v1.0
# This is a ~20GB docker image. It takes a long time to pull.
cd ~/AITemplate/examples/05_stable_diffusion/
sh run_ait_sd_webui.sh
# This gave us an error about
#    [05:55:20] model_interface.cpp:94: Error: DeviceMalloc(&result, n_bytes) API call failed: 
#    no ROCm-capable device is detected at model_interface.cpp, line49
# Per: https://www.reddit.com/r/ROCm/comments/177pwxv/how_can_i_set_up_linux_rocm_pytorch_for_7900xtx/
# We rerun the container with some extra parameters to give it access to our GPU.
docker run -it --privileged --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --device=/dev/kfd --device=/dev/dri --group-add video --ipc=host aska0096/rocm5.7_ait_ck_navi31_sd2:v1.0
cd ~/AITemplate/examples/05_stable_diffusion/
sh run_ait_sd_webui.sh
# This got us to "Uvicorn running on http://0.0.0.0:5000"
# Nice. Oh. We haven't exposed any ports...
docker run -it --rm -p 5500:5000 --privileged --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --device=/dev/kfd --device=/dev/dri --group-add video --ipc=host aska0096/rocm5.7_ait_ck_navi31_sd2:v1.0 
cd ~/AITemplate/examples/05_stable_diffusion/ && sh run_ait_sd_webui.sh
# I think :5000 on the local host is probably already in use, so we'll just dodge the possibility of a collision. 
# Uhh. Well now what? connecting to http://localhost:5500 in our browser returns a 404.
# Maybe it's the Streamlit server that we should be looking at?
docker run -it --rm -p 5500:5000 -p 5501:8501 --privileged --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --device=/dev/kfd --device=/dev/dri --group-add video --ipc=host aska0096/rocm5.7_ait_ck_navi31_sd2:v1.0 
cd ~/AITemplate/examples/05_stable_diffusion/ && sh run_ait_sd_webui.sh
# Ah yeah, that did it. Now we can see the Stable Diffusion test at 5501. And we can also see our VRAM utilization increase by ~6 GB when we run the script. Now just to test the performance! Nice. We get <2s to generate an image. 
# Now can we generalize this to a more useful model?
```