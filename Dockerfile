# syntax=docker/dockerfile-upstream:master-labs

FROM osrf/ros:humble-desktop-full
LABEL maintainer="Bhargav Chandaka <bhargav9@illinois.edu>"
ENV USER_NAME="user"

# Use local mirrors for faster deployment
RUN sed -i -e 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//mirror:\/\/mirrors\.ubuntu\.com\/mirrors\.txt/' /etc/apt/sources.list

RUN sudo apt-get update
# # Create ubuntu user with sudo privileges
RUN useradd -ms /bin/bash $USER_NAME && \
    usermod -aG sudo $USER_NAME && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    sed -i 's/required/sufficient/' /etc/pam.d/chsh && \
    touch /home/$USER_NAME/.sudo_as_admin_successful

USER $USER_NAME
# Install zsh
RUN sudo apt-get install -y zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN chsh -s /usr/bin/zsh $USER_NAME
# RUN echo 'ZSH_THEME="agnoster"' >> /home/$USER_NAME/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
COPY ./docker_settings/.zshrc /home/$USER_NAME/.zshrc

# Install tmux and set up tmuxinator
RUN sudo apt install -y tmux
RUN mkdir $HOME/tmp && export TMPDIR=$HOME/tmp
RUN sudo gem install tmuxinator

# install ROS Dependencies vis rosdep
# RUN sudo apt-get install -y python3-rosdep
# RUN rosdep update
# COPY --parents src/**/*.xml /tmp
# RUN cd /tmp && ls && rosdep install --from-paths . --ignore-src -r -y

# Python dependencies
RUN sudo apt-get install -y python3-pip
COPY ./requirements.txt /tmp
RUN pip3 install -r /tmp/requirements.txt

WORKDIR /home/$USER_NAME/ros_ws
# RUN echo 'source /opt/ros/humble/setup.zsh 2>/dev/null || true' > /home/$USER_NAME/.zshrc

CMD ["/usr/bin/zsh"]
