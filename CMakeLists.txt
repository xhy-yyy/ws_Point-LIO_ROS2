cmake_minimum_required(VERSION 3.5)
project(point_lio)

SET(CMAKE_BUILD_TYPE "Release")

add_definitions(-DROOT_DIR=\"${CMAKE_CURRENT_SOURCE_DIR}/\")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fexceptions" )
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -march=native -pthread -fexceptions")

#add_compile_definitions(BOOST_BIND_GLOBAL_PLACEHOLDERS)

# find_package(OpenMP QUIET)
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}   ${OpenMP_C_FLAGS}")

find_package(PythonLibs REQUIRED)
find_path(MATPLOTLIB_CPP_INCLUDE_DIRS "matplotlibcpp.h")

# Find packages
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclpy REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(nav_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(pcl_ros REQUIRED)
find_package(pcl_conversions REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(tf2_eigen REQUIRED)
find_package(livox_ros_driver2 REQUIRED)
find_package(visualization_msgs REQUIRED)


find_package(Eigen3 REQUIRED)
find_package(PCL REQUIRED)
find_package(TBB REQUIRED)
find_package(glog REQUIRED)

message(Eigen: ${EIGEN3_INCLUDE_DIR})

include_directories(
	${catkin_INCLUDE_DIRS} 
  ${EIGEN3_INCLUDE_DIR}
  ${PCL_INCLUDE_DIRS}
  ${PYTHON_INCLUDE_DIRS}
  include)

link_directories(
	include
	${PCL_LIBRARY_DIRS}
)

# Declare a ROS2 executable
add_executable(pointlio_mapping src/laserMapping.cpp src/li_initialization.cpp src/parameters.cpp src/preprocess.cpp src/Estimator.cpp src/IMU_Processing.cpp)
ament_target_dependencies(pointlio_mapping
        rclcpp
        rclpy
        geometry_msgs
        nav_msgs
        sensor_msgs
        pcl_ros
        pcl_conversions
        tf2_ros
        tf2_eigen
        livox_ros_driver2
        visualization_msgs
)
target_link_libraries(pointlio_mapping ${PYTHON_LIBRARIES} TBB::tbb glog::glog)
target_include_directories(pointlio_mapping PRIVATE ${PYTHON_INCLUDE_DIRS})

# Install the executable
install(TARGETS
        pointlio_mapping
        DESTINATION lib/${PROJECT_NAME}
)

install(
        DIRECTORY config launch rviz_cfg
        DESTINATION share/${PROJECT_NAME}
)

# Export dependencies
ament_export_dependencies(rclcpp rclpy geometry_msgs nav_msgs sensor_msgs pcl_ros pcl_conversions tf2_ros tf2_eigen livox_ros_driver2 Eigen3)

ament_package()
