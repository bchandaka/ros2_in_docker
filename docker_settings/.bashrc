export HISTFILE=/home/user/colcon_ws/.bash_history
source /opt/ros/humble/setup.bash 2>/dev/null || true
source /home/user/colcon_ws/install/setup.bash 2>/dev/null || true
alias colcon_build='colcon build --symlink-install && source install/setup.bash && source ~/.bashrc'
# argcomplete for ros2 & colcon
eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"
export TURTLEBOT3_MODEL='waffle'