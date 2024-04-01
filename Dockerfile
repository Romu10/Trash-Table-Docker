# Start from ROS base image
FROM osrf/ros:humble-desktop-full

# Make a catkin workspace
WORKDIR /
RUN mkdir -p /ros2_ws/src
RUN mkdir -p /webpage_ws/src
RUN mkdir -p /simulation_ws/src
WORKDIR /ros2_ws/src

# Install Git
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
    ros-humble-ros2-controllers


# COPY ./ /ros2_ws/src/move_and_turn

# Git clone simulation
WORKDIR /simulation_ws/src
RUN git clone https://github.com/Romu10/Cafeteria-Simulation-Trash-Table.git

# Build simulation workspace
WORKDIR /simulation_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash; cd /simulation_ws; colcon build"

# Build ROS packages
WORKDIR /ros2_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash; cd /ros2_ws; colcon build"

# Source the workspace every time a new shell is opened in the container
RUN echo source /ros2_ws/install/setup.bash >> ~/.bashrc

# Set the entry point to start a bash shell
CMD ["/bin/bash"]

# RUN
# xhost local:docker
# docker run -it --rm --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix trashbot_simulation:latest
