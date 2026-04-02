<p align="center">
  <img src="https://img.shields.io/badge/ROS-Noetic-blue?style=for-the-badge&logo=ros" alt="ROS Version"/>
  <img src="https://img.shields.io/badge/Ubuntu-20.04-orange?style=for-the-badge&logo=ubuntu" alt="Ubuntu Version"/>
  <img src="https://img.shields.io/badge/Gazebo-11-green?style=for-the-badge" alt="Gazebo Version"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License"/>
</p>

<h1 align="center">🤖 TRACER ROS Navigation</h1>

<p align="center">
  <b>基于 ROS Noetic 的 AgileX Tracer 底盘 SLAM 与自主导航系统</b>
</p>

<p align="center">
  <a href="#-功能特性">功能特性</a> •
  <a href="#-快速开始">快速开始</a> •
  <a href="#-系统架构">系统架构</a> •
  <a href="#-使用指南">使用指南</a> •
  <a href="#-参考文档">参考文档</a>
</p>

---

## ✨ 功能特性

| 功能 | 描述 |
|:---:|:---|
| 🗺️ **SLAM 建图** | 使用 GMapping 算法实现 2D 激光 SLAM |
| 🧭 **自主导航** | 基于 ROS Navigation Stack 实现路径规划与避障 |
| 🎮 **Gazebo 仿真** | 完整的仿真环境支持，包含传感器模拟 |
| 📊 **RViz 可视化** | 实时显示地图、路径、传感器数据 |

## 🖥️ 环境要求

| 组件 | 版本 |
|:---:|:---:|
| 操作系统 | Ubuntu 20.04 LTS |
| ROS | Noetic |
| Gazebo | 11 |
| Python | 3.8+ |

## 📦 机器人平台参数

```
┌──────────────────────────────────────────┐
│           AgileX Tracer 底盘             │
├──────────────────────────────────────────┤
│  驱动方式      │  差速驱动               │
│  轮距          │  0.34 m                 │
│  轮径          │  0.16 m                 │
│  最大线速度    │  1.5 m/s                │
│  最大角速度    │  1.5 rad/s              │
├──────────────────────────────────────────┤
│  激光雷达      │  2D LiDAR, 360°, 12m    │
│  IMU          │  6轴, 100Hz             │
└──────────────────────────────────────────┘
```

## 🚀 快速开始

### 1️⃣ 克隆仓库

```bash
cd ~/
git clone https://github.com/Pandakingxbc/tracer_nav.git ROS1
cd ROS1
```

### 2️⃣ 安装依赖

```bash
# 安装 ROS 导航相关包
sudo apt-get install -y \
    ros-noetic-navigation \
    ros-noetic-amcl \
    ros-noetic-map-server \
    ros-noetic-move-base \
    ros-noetic-dwa-local-planner \
    ros-noetic-diff-drive-controller \
    ros-noetic-joint-state-controller \
    ros-noetic-gazebo-ros \
    ros-noetic-gazebo-ros-control

# 安装 ugv_sdk 依赖
sudo apt-get install -y libasio-dev
```

### 3️⃣ 克隆额外依赖包

```bash
cd ~/ROS1/catkin_ws/src

# GMapping SLAM
git clone https://github.com/ros-perception/slam_gmapping.git
git clone https://github.com/ros-perception/openslam_gmapping.git

# 键盘遥控
git clone https://github.com/ros-teleop/teleop_twist_keyboard.git

# AgileX UGV SDK
git clone https://github.com/agilexrobotics/ugv_sdk.git
```

### 4️⃣ 编译工作空间

```bash
cd ~/ROS1/catkin_ws
source /opt/ros/noetic/setup.bash
catkin_make

# 添加到环境变量
echo "source ~/ROS1/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────────────────────┐
│                        ROS Master                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │   Gazebo     │    │   Sensors    │    │  Controllers │      │
│  │  Simulation  │───▶│  (LiDAR/IMU) │───▶│ (diff_drive) │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│  ┌──────────────────────────────────────────────────────┐      │
│  │                     TF Tree                          │      │
│  │   map ──▶ odom ──▶ base_link ──▶ laser_link         │      │
│  └──────────────────────────────────────────────────────┘      │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │    SLAM      │    │    AMCL      │    │  move_base   │      │
│  │  (GMapping)  │    │(Localization)│    │ (Navigation) │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 📂 项目结构

```
ROS1/
├── 📁 catkin_ws/              # Catkin 工作空间
│   └── 📁 src/
└── 📁 tracer_ros/             # Tracer ROS 功能包
    ├── 📁 tracer_base/        # 底盘驱动
    ├── 📁 tracer_bringup/     # 启动脚本
    ├── 📁 tracer_description/ # URDF 模型
    ├── 📁 tracer_gazebo_sim/  # Gazebo 仿真
    ├── 📁 tracer_msgs/        # 自定义消息
    ├── 📁 tracer_slam/        # SLAM 功能包 ⭐
    └── 📁 tracer_navigation/  # 导航功能包 ⭐
```

## 📖 使用指南

### 🗺️ SLAM 建图

```bash
# 启动 SLAM 仿真 (包含 Gazebo + RViz)
roslaunch tracer_slam tracer_slam_sim.launch

# 控制机器人移动建图
rosrun teleop_twist_keyboard teleop_twist_keyboard.py \
    cmd_vel:=/tracer_diff_drive_controller/cmd_vel

# 保存地图
rosrun map_server map_saver -f ~/ROS1/tracer_ros/tracer_navigation/maps/my_map
```

### 🧭 自主导航

```bash
# 启动导航仿真 (包含 Gazebo + RViz + AMCL + move_base)
roslaunch tracer_navigation tracer_nav_sim.launch

# 在 RViz 中:
# 1. 点击 "2D Pose Estimate" 设置初始位姿
# 2. 点击 "2D Nav Goal" 设置导航目标
```

### ⌨️ 命令行发送导航目标

```bash
rostopic pub /move_base_simple/goal geometry_msgs/PoseStamped "
header:
  frame_id: 'map'
pose:
  position: {x: 2.0, y: 1.0, z: 0.0}
  orientation: {w: 1.0}"
```

## 🛠️ 调试命令

```bash
# 查看 TF 树
rosrun tf view_frames && evince frames.pdf

# 检查话题
rostopic list | grep -E "scan|odom|cmd_vel|map"

# 检查 TF 变换
rosrun tf tf_echo map base_link

# 查看导航状态
rostopic echo /move_base/status
```

## 📚 参考文档

- [ROS Navigation Stack](http://wiki.ros.org/navigation)
- [GMapping](http://wiki.ros.org/gmapping)
- [AMCL](http://wiki.ros.org/amcl)
- [move_base](http://wiki.ros.org/move_base)
- [diff_drive_controller](http://wiki.ros.org/diff_drive_controller)

## 📄 详细文档

完整的技术文档请参阅: [TRACER_SLAM_NAV_GUIDE.md](tracer_ros/TRACER_SLAM_NAV_GUIDE.md)

---

<p align="center">
  <b>Made with ❤️ by tracer_nav</b>
</p>
