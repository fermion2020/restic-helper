#!/bin/bash

# Author: https://github.com/fermion2020
# Date: 31-07-2025


show_help() {
  echo "Usage: $0 <number> [--host <name>] [--restore <snapshot_id>] [--include <path-to-data>]"
  echo
  echo "Arguments:"
  echo "  <number>             Required. Used to construct BACKUPxx_ environment variable names."
  echo
  echo "Options:"
  echo "  --host <name>        Optional. Adds --host to restic commands."
  echo "  --restore <id>       Optional. If set, switches to restore mode and requires snapshot ID."
  echo "  --include <path>     Optional. Use with restore to include specific path."
  echo "  -h, --help           Show this help message and exit."
  echo
  echo "Examples:"
  echo "  $0 08                              List snapshots for BACKUP08"
  echo "  $0 8 --host myhost                 List snapshots with host filter"
  echo "  $0 5 --restore abc123              Restore snapshot with ID abc123"
  echo "  $0 07 --restore abc123 --include /data"
  exit 0
}

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
fi


number=$(printf "%02d" "$1")
shift

host=""
restore_flag=false
snapshot_id=""
include_path=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)
      host="$2"
      shift 2
      ;;
    --restore)
      restore_flag=true
      snapshot_id="$2"
      shift 2
      ;;
    --include)
      include_path="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Build environment variable names
repo_var="BACKUP${number}_REPOSITORY_PATH"
pass_var="BACKUP${number}_REPOSITORY_PASS"
path_var="BACKUP${number}_SNAPSHOT_PATH"

# Retrieve environment variables
repo="${!repo_var}"
pass="${!pass_var}"
path="${!path_var}"

if [[ -z "$repo" || -z "$pass" || -z "$path" ]]; then
  echo "One or more environment variables are missing: $repo_var, $pass_var, $path_var"
  exit 2
fi

cmd="echo \"$pass\" | restic"

if $restore_flag; then
  if [[ -z "$snapshot_id" ]]; then
    echo "Snapshot ID required with --restore"
    exit 3
  fi

  cmd+=" restore $snapshot_id --cache-dir \"/cache/\" --path \"$path\" --repo \"$repo\" --target /restore"

  [[ -n "$host" ]] && cmd+=" --host \"$host\""
  [[ -n "$include_path" ]] && cmd+=" --include \"$include_path\""
else
  cmd+=" snapshots --cache-dir \"/cache/\" --path \"$path\" --repo \"$repo\""
  [[ -n "$host" ]] && cmd+=" --host \"$host\""
fi

eval "$cmd"
