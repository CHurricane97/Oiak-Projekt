# Docker image that is capable of runnning and debuggin this code
# Start contianer with
# docker run -it -v [path_to_src_folder]:[path_you_wish_to_mount_to] --cap-add=SYS_PTRACE --security-opt seccomp=unconfined ttt_as bash

FROM ubuntu:latest
RUN apt-get update
RUN apt-get -y install nasm\
                    gdb\
                    make\
                    gcc\
                    vim\
                    libc6-dev-i386