### devcontainer

This repository stores a Dockerfile that I use for personal projects. It contains zsh with some of its plugins, gcc, conda , texlive and various useful packages.

To build the image:
```bash
docker build --rm -t devcontainer .
```

To run the container:
```bash
docker run -it -d --privileged --name devcontainer -v //var/run/docker.sock:/var/run/docker.sock -p 2222:22 -p 8888:8888 -p 12100-12200:12100-12200 devcontainer
```
Use `//var/run/docker.sock:/var/run/docker.sock` instead when running in Windows.