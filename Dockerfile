# Start from ROS base image
FROM osrf/ros:humble-desktop-full

# Make a catkin workspace
WORKDIR /
RUN mkdir -p home/user/ros2_ws/src
RUN mkdir -p home/user/webpage_ws/src
RUN mkdir -p home/user/simulation_ws/src
WORKDIR /ros2_ws/src

# Install packages
RUN apt-get update && apt-get install -y \
    git \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-cartographer \
    ros-humble-teleop-twist-keyboard \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-plugins \
    ros-humble-gazebo-msgs \ 
    ros-humble-gazebo-ros \
    ros-humble-gazebo-ros2-control \ 
    ros-humble-topic-tools \
    ros-dev-tools \ 
    ros-humble-joint-state-publisher \
    ros-humble-robot-state-publisher \
    ros-humble-ament-cmake \
    ros-humble-angles \
    ros-humble-controller-manager \
    ros-humble-gazebo-dev \
    ros-humble-hardware-interface \
    ros-humble-pluginlib \
    ros-humble-rclcpp \
    ros-humble-rclpy \
    ros-humble-yaml-cpp-vendor \
    ros-humble-ros2-control \
    ros-humble-position-controllers \
    ros-humble-ros2-controllers \
    python3-pip \
    nano

# Install scikit learn
RUN pip install -U scikit-learn

# Git clone scripts
WORKDIR /home/user/ros2_ws/src
RUN git clone https://github.com/Romu10/Trash-Table-Cleaner-Robot.git .

# Git clone simulation
WORKDIR /home/user/simulation_ws/src
RUN git clone https://github.com/Romu10/Cafeteria-Simulation-Trash-Table.git .

# Build simulation workspace
WORKDIR /home/user/simulation_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash; colcon build; source install/setup.bash"

# Build ROS packages
WORKDIR /home/user/ros2_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash; colcon build; source install/setup.bash"

# Source the workspace every time a new shell is opened in the container
RUN echo source /ros2_ws/install/setup.bash >> ~/.bashrc

# Set the entry point to start a bash shell
CMD ["/bin/bash"]

# RUN
# xhost local:docker
# docker run -it --rm --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix trashbot_simulation:latest
