.PHONY:build clean dev docker run
CONTAINER_NAME?=humble
ROS_BAGS?=./bags
export CONTAINER_NAME
export ROS_BAGS

default:build
	@docker compose run --rm ros2 tmuxinator start -p ./docker_settings/.tmuxinator.yaml

dev:
	@docker compose run --rm ros2 tmuxinator start -p ./docker_settings/.tmuxinator.yaml

build:
	@docker compose run --rm ros2 colcon build --symlink-install
	
docker:
	docker build -t ros2_in_docker/humble:$(CONTAINER_NAME) .

clean:
	@docker compose run --rm ros catkin clean

run:
	@docker compose run -e --rm ros2 