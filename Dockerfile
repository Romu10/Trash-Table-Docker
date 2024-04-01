# Start from ROS base image
FROM osrf/ros:humble-desktop-full

# Make a catkin workspace
WORKDIR /
RUN mkdir -p /ros2_ws/src
RUN mkdir -p /webpage_ws/src
WORKDIR /ros2_ws/src

# Install Git
RUN apt-get update && apt-get install -y \
    git

# COPY ./ /ros2_ws/src/move_and_turn

WORKDIR /ros2_ws

# Build your ROS packages
RUN /bin/bash -c "source /opt/ros/humble/setup.bash; cd /ros2_ws; colcon build"

# Source the workspace every time a new shell is opened in the container
RUN echo source /ros2_ws/install/setup.bash >> ~/.bashrc

# Set the entry point to start a bash shell
CMD ["/bin/bash"]