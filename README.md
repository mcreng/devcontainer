### devcontainer

This repository stores a Dockerfile that I use for personal projects. It contains zsh with some of its plugins, gcc, conda , texlive and various useful packages.

To build the image:
```bash
docker build --rm -t devcontainer:{tag} .
```

To run the container (requires a volume called `code`):
```bash
docker run -it -d --privileged --name devcontainer -v //var/run/docker.sock:/var/run/docker.sock -p 2222:22 -p 8888:8888 -p 12100-12200:12100-12200 devcontainer
docker run -it -d --privileged --name devcontainer-{tag} -v //var/run/docker.sock:/var/run/docker.sock -v code:/logs/work -p 2223:22 -p 8889:8888 -p 12300-12400:12300-12400 devcontainer:{tag}
```
