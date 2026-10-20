#!/usr/bin/env bash
set -euo pipefail
mapping_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
workspace_dir="$(cd -- "$mapping_dir/../.." && pwd)"
default_livox_workspace="$(dirname -- "$workspace_dir")/ws_livox"
livox_workspace="${LIVOX_WORKSPACE:-$default_livox_workspace}"
sdk_prefix="${LIVOX_SDK2_PREFIX:-$livox_workspace/.deps/livox_sdk2}"
ros_setup="${ROS_SETUP_FILE:-/opt/ros/humble/setup.bash}"
if [[ ! -f "$ros_setup" || ! -f "$livox_workspace/install/setup.bash" || ! -f "$workspace_dir/install/setup.bash" ]]; then
  printf 'ROS or a workspace setup is missing; build both workspaces first.\n' >&2
  exit 1
fi
export LD_LIBRARY_PATH="$sdk_prefix/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
set +u
source "$ros_setup"
source "$livox_workspace/install/setup.bash"
source "$workspace_dir/install/setup.bash"
set -u
exec ros2 launch point_lio mapping_mid360.launch.py "$@"
