# docker-petclinic

To run:
```
docker pull graphwalker/petclinic
docker run -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/developer/.Xauthority --net=host --pid=host --ipc=host graphwalker/petclinic
```
