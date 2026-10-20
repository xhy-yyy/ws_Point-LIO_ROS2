# Point-LIO_ROS2 — 单 MID360 定位建图工程

由 [xhy-yyy](https://github.com/xhy-yyy) 维护的 ROS2 Humble 单 MID360 定位建图工程，
提供配套驱动接入、实际配置、通用依赖查找，以及构建和启动脚本。

核心定位算法来自 Point-LIO；本工程基于 `uavfly/Point-LIO_ROS2` 的 `super` 版本整理，
沿用其中的 OctVoxMap 和 TBB 并行处理。来源、版本和作者记录见 [CREDITS.md](CREDITS.md)，
原版说明见 [README_UPSTREAM.md](README_UPSTREAM.md)。

## 本工程提供的内容

- 对接 [配套 MID360 驱动工程](https://github.com/xhy-yyy/livox_ros_driver2) 的自定义点云和 IMU。
- 每处理完一帧点云发布一次里程计和 TF；正常处理 20 Hz 点云时输出通常接近 20 Hz，需实测确认。
- 默认关闭 RViz，节点输出写入日志，支持按需打开可视化。
- glog 通过 CMake 查找，构建文件中没有个人工程的绝对路径。
- 提供环境依赖、构建、启动和参数说明。

ROS 包名为 `point_lio`，节点可执行文件为 `pointlio_mapping`。

| 数据 | 话题 / 坐标系 |
| --- | --- |
| 输入点云 | `/livox/lidar`，Livox `CustomMsg` |
| 输入 IMU | `/livox/imu` |
| 位姿里程计 | `/aft_mapped_to_init` |
| 世界坐标系点云 | `/cloud_registered` |
| 轨迹 | `/path` |
| TF | `camera_init -> body` |

## 准备环境和构建

面向 Ubuntu 22.04 / ROS2 Humble。先完成配套 `livox_ros_driver2` 工程的构建，再执行：

```bash
sudo apt update
sudo apt install build-essential cmake libeigen3-dev libpcl-dev libtbb-dev \
  libgoogle-glog-dev python3-dev python3-numpy python3-matplotlib \
  python3-colcon-common-extensions ros-humble-pcl-ros \
  ros-humble-pcl-conversions ros-humble-tf2-eigen \
  ros-humble-tf2-geometry-msgs ros-humble-visualization-msgs ros-humble-rviz2
mkdir -p ~/ws_mid360/src
git clone https://github.com/xhy-yyy/Point-LIO_ROS2.git ~/ws_mid360/src/Point-LIO_ROS2
bash ~/ws_mid360/src/Point-LIO_ROS2/scripts/build_humble.sh
```

脚本默认寻找同级 `ws_livox`，路径不同时使用：

```bash
LIVOX_WORKSPACE=/path/to/ws_livox bash scripts/build_humble.sh
```

自定义 glog 安装可通过 `CMAKE_PREFIX_PATH` 指定前缀。
首次发布需将本项目推送到上述个人仓库后，克隆地址才可用于获取此版本。

## 运行

驱动和定位分别使用一个终端：

```bash
# 终端 1
bash ~/ws_livox/src/livox_ros_driver2/scripts/run_mid360.sh
```

```bash
# 终端 2
bash ~/ws_mid360/src/Point-LIO_ROS2/scripts/run_mid360.sh
# 打开 RViz
bash ~/ws_mid360/src/Point-LIO_ROS2/scripts/run_mid360.sh rviz:=true
```

## 参数

默认加载 `config/mid360.yaml`，保留现有工作区的设置：

| 参数 | 当前值 |
| --- | --- |
| `odometry.publish_odometry_without_downsample` | `false` |
| `point_filter_num` | `1` |
| `space_down_sample` | `true` |
| 表面 / 地图滤波栅格 | `0.5` / `0.5` |
| `mapping.ivox_grid_resolution` | `0.5` |
| `mapping.extrinsic_T` | `[0.04165, 0.02326, -0.0284]` |
| `mapping.extrinsic_R` | 单位矩阵 |
| `mapping.extrinsic_est_en` | `false` |
| `mapping.lidar_time_inte` | `0.1` |

外参和时间参数为当前快照值，不代表已完成适用于所有 MID360 安装的标定。
使用时需核对实际外参，以及与 20 Hz 驱动输入配合时的时间设置。
修改源码配置或启动文件后，重新构建以更新安装目录。

## 维护和验证

维护分支为 `main`，本仓库从当前工程快照建立独立提交历史。
今后引入算法或 ROS2 上游的更新时，按补丁审阅、合入并验证。

本次整理前，相同的算法源码和构建脚本已在 x86_64 / ROS2 Humble 环境编译通过，
并与配套驱动完成动态库依赖检查。测试使用通过 `CMAKE_PREFIX_PATH` 指定的已有 glog。
独立发布整理未改动算法源码，尚未进行实机运行或定位精度测试。

根目录 `LICENSE`、`include/IKFoM/LICENSE` 及第三方文件中的许可证和署名继续保留。
