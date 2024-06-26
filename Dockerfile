# Start from ROS base image
FROM osrf/ros:humble-desktop-full

# Make a catkin workspace
WORKDIR /
RUN mkdir -p home/user/ros2_ws/src
RUN mkdir -p home/user/webpage_ws/
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
RUN pip install pymongo
RUN pip install httpserver
RUN pip install tornado

# Git clone scripts
WORKDIR /home/user/ros2_ws/src
RUN git clone -b main https://github.com/Romu10/Trash-Table-Cleaner-Robot.git .
RUN git clone https://github.com/RobotWebTools/rosbridge_suite.git 

# Git clone simulation
WORKDIR /home/user/simulation_ws/src
RUN git clone https://github.com/Romu10/Cafeteria-Simulation-Trash-Table.git .

# Git clone webpage
WORKDIR /home/user/webpage_ws
RUN git clone https://github.com/Romu10/Trash-Table-Webpage.git .

# Build simulation workspace
WORKDIR /home/user/simulation_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash; colcon build; source install/setup.bash"

# Build ROS packages
WORKDIR /home/user/ros2_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash; colcon build; source install/setup.bash"

# Source the workspace every time a new shell is opened in the container
RUN echo source /home/user/ros2_ws/install/setup.bash >> ~/.bashrc

# Set the entry point to start a bash shell
CMD ["/bin/bash"]

EXPOSE 7000

# RUN THIS COMMANDS TO START THE CONTAINER
# docker rm -f $(docker ps -aq)
# xhost local:docker
# docker build --no-cache -t cafeteria:simulation .    
# docker run -it -d --privileged -p 7000:7000 --name cafeteria_sim -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix cafeteria:simulation
# docker exec -it cafeteria_sim bash

# COMMANDS TO START THE PROGRAM
# - TELEOPERATE
#   ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args --remap cmd_vel:=/diffbot_base_controller/cmd_vel_unstamped
# - SIMULATION
#   ros2 launch the_construct_office_gazebo warehouse_rb1.launch.xml 
# - NAV2
#   ros2 launch path_planner_server pathplanner.launch.py 
# - NEEDED NODES
#   ros2 launch nav2_interface trash_table_pickup.launch.py 
# - SCRIPT 
#   python3 src/nav2_interface/nav2_interface/look_for_trash_table.py 
# - WEB 