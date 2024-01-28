# ros2_in_docker
A ready-to-go dev environment for using ROS2 in docker easily. Supports GUI tools, networking, almost like a standard ROS2 install.

This repo is essentially a ros2 version of [ros_in_docker](https://github.com/nachovizzo/ros_in_docker). I chose to install some of the "dotfile" dependencies(tmux, oh-my-zsh) from scratch to make the Dockerfile more understandable. 

## Usage
### Dependencies
Works in WSL2 on Windows or Ubuntu. Assumes [docker engine](https://docs.docker.com/engine/install/ubuntu/)(recommended for Ubuntu) or [docker desktop](https://www.docker.com/products/docker-desktop/) is installed.
*Note: Make is used here as a shortcut to typing out common commands, but it is not necessary*
### Quickstart
1. Setup
    - Clone any ros packages you want to use into `./src`
    - If you have additional dependencies, add them to the `Dockerfile` in the `# Install ROS2/Additional dependencies` section
        - *Note: By default, the `Dockerfile` will find all the `package.xml` files under `src/` and install any dependencies listed in them using `rosdep`*
    - Add any python requirements to `requirements.txt`
    - Any required rosbags can be placed in `bags/`
2. `make docker`
    - Re-run this command whenever you make any changes to your dependencies or the `Dockerfile`
    - If you just create new ROS2 packages under `src/`, you don't need to re-build the docker container
3. `make`
    - Builds the packages in `src/` and this repo will become your colcon workspace in the container
4. A tmux window will open and you can use any commands to run ROS2 scripts, build with colcon, and pretty much do anything you can do in a normal terminal.
5. `make exit` to close the container

### Other notes
- For a nice dev environment, use VSCode with the remote development/devcontainers extension and you can remote into the docker container directly
- If you want to change the rosbag directory path, just update the `ROS_BAGS` variable in the `Makefile`
- You can hold right-click in the tmux window and drag the cursor to a desired command if you don't want to use tmux keyboard shortcuts
- Scrolling will also work in tmux windows by default
- You can edit any `zsh`, `tmuxinator`, or `tmux` configs by editing the files in docker_settings