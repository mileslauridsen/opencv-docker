# opencv-docker

OpenCV 4.0 compiled in a Docker Ubuntu image. 

Built from these instructions:

https://www.pyimagesearch.com/2018/08/15/how-to-install-opencv-4-on-ubuntu/

## Building with docker
```docker build -t vfx/opencv .```

## Running image in an interactive bash shell
```docker run -it --entrypoint='bash' vfx/opencv```
