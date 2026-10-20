#!/usr/bin/env bash
set -euo pipefail
mapping_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$(dirname -- "$mapping_dir")"
if [[ "$(basename -- "$source_dir")" != src ]]; then
  printf 'Clone Point-LIO under a ROS2 workspace src/ directory first.\n' >&2
  exit 1
fi
workspace_dir="$(dirname -- "$source_dir")"
default_livox_workspace="$(dirname -- "$workspace_dir")/ws_livox"
livox_workspace="${LIVOX_WORKSPACE:-$default_livox_workspace}"
sdk_prefix="${LIVOX_SDK2_PREFIX:-$livox_workspace/.deps/livox_sdk2}"
ros_setup="${ROS_SETUP_FILE:-/opt/ros/humble/setup.bash}"
build_jobs="${BUILD_JOBS:-2}"
if [[ ! -f "$ros_setup" || ! -f "$livox_workspace/install/setup.bash" ]]; then
  printf 'Build the Livox workspace first; set LIVOX_WORKSPACE if its path differs.\n' >&2
  exit 1
fi
export CMAKE_PREFIX_PATH="$sdk_prefix${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
export LD_LIBRARY_PATH="$sdk_prefix/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
if [[ ! "$build_jobs" =~ ^[1-9][0-9]*$ ]]; then
  printf 'BUILD_JOBS must be a positive integer.\n' >&2
  exit 1
fi
export CMAKE_BUILD_PARALLEL_LEVEL="$build_jobs"
export MAKEFLAGS="${MAKEFLAGS:--j$build_jobs}"
set +u
source "$ros_setup"
source "$livox_workspace/install/setup.bash"
set -u
cd "$workspace_dir"
colcon build --base-paths "$mapping_dir" --packages-select point_lio \
  --parallel-workers 1 \
  --cmake-args -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF
