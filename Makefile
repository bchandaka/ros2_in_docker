.PHONY : default dev build_docker docker clean_docker run build clean exit
CONTAINER_NAME?=humble
ROS_BAGS?=./bags
export CONTAINER_NAME
export ROS_BAGS

# Outside the container
default:build_docker
	@docker compose run --rm ros2 tmuxinator start -p ./docker_settings/.tmuxinator.yaml

dev:
	@docker compose run --rm ros2 tmuxinator start -p ./docker_settings/.tmuxinator.yaml

build_docker:
	@docker compose run --rm ros2 colcon build --symlink-install
	
docker:
	docker build -t ros2_in_docker/humble:$(CONTAINER_NAME) .

clean_docker:
	@docker compose run --rm ros2 rm -r build install log

run:
	@docker compose run --rm ros2 

# Inside the container
build:
	colcon build --symlink-install
	zsh ./install/setup.zsh
clean:
	rm -r build install log
exit:
	tmux kill-server