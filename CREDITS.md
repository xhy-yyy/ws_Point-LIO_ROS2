# 来源和维护记录

本独立仓库维护者：[xhy-yyy](https://github.com/xhy-yyy)。
本地维护内容为单 MID360 配套配置、每帧一次的里程计输出设置、启动方式、
通用 glog 查找、构建和启动脚本、使用说明及发布整理。

## Point-LIO 与 ROS2 版本

- 原始 Point-LIO 项目：https://github.com/hku-mars/Point-LIO
- 原项目 README 记录的开发者：Dongjiao He（贺东娇）和 Wei Xu（徐威）。
- 本工程直接采用的 ROS2 适配来源：https://github.com/uavfly/Point-LIO_ROS2
- 版本起点：`super`，`59affa2957c0e487f3b6493744e25489a8212914`。
- OctVoxMap 集成与 TBB 并行处理来自该上游版本。

原版说明原样保存在 `README_UPSTREAM.md`。
根目录 `LICENSE`、`include/IKFoM/LICENSE` 及第三方文件中的版权和许可证声明均保留。
本工程不以一个新许可证替换这些组件各自的声明。

当前工程快照与此前准备提交的对应关系见 `SOURCE_VERSION.json`。
本仓库的 Git 历史从独立工程快照开始，来源和作者信息通过以上记录及源码声明保留。
