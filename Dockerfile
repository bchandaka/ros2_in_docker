# syntax=docker/dockerfile-upstream:master-labs

FROM osrf/ros:humble-desktop-full
LABEL maintainer="Bhargav Chandaka <bhargav9@illinois.edu>"
ENV USER_NAME="user"
ENV TERM="xterm-256color"

# Use local mirrors for faster deployment
RUN sed -i -e 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//mirror:\/\/mirrors\.ubuntu\.com\/mirrors\.txt/' /etc/apt/sources.list

RUN sudo apt-get update
# Create ubuntu user with sudo privileges
RUN useradd -ms /bin/bash $USER_NAME && \
    usermod -aG sudo $USER_NAME && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    sed -i 's/required/sufficient/' /etc/pam.d/chsh && \
    touch /home/$USER_NAME/.sudo_as_admin_successful

USER $USER_NAME

# Install oh-my-zsh
RUN sudo apt-get install -y zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN chsh -s /usr/bin/zsh $USER_NAME
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
COPY ./docker_settings/.zshrc /home/$USER_NAME/.zshrc
RUN echo 'export HISTFILE=/home/$USER_NAME/colcon_ws/.zsh_history' >> /home/$USER_NAME/.zshrc_local
RUN echo 'source /opt/ros/humble/setup.zsh 2>/dev/null || true' >> /home/$USER_NAME/.zshrc_local
RUN echo 'source /home/$USER_NAME/colcon_ws/install/setup.zsh 2>/dev/null || true' >> /home/$USER_NAME/.zshrc_local

# Install tmux & tmuxinator
RUN sudo apt install -y tmux
RUN mkdir $HOME/tmp && export TMPDIR=$HOME/tmp
RUN sudo gem install tmuxinator
WORKDIR /home/$USER_NAME
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf
COPY ./docker_settings/.tmux.conf.local /home/$USER_NAME/

# Install ROS2/Additional dependencies
RUN sudo apt-get install -y htop

# Update dependencies with rosdep
WORKDIR /home/$USER_NAME/colcon_ws
RUN sudo apt-get install -y python3-rosdep
RUN rosdep update
COPY --parents src/**/*.xml /tmp
COPY --parents src/**/COLCON_IGNORE /tmp
RUN cd /tmp && rosdep install -i --from-path . --rosdistro humble -y

# Install Python dependencies
RUN sudo apt-get install -y python3-pip
COPY ./requirements.txt /tmp
RUN pip3 install -r /tmp/requirements.txt

WORKDIR /home/$USER_NAME/colcon_ws
USER root

CMD ["/usr/bin/zsh"]
