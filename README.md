# restic-helper## 

## 📄 Description

A Bash helper script designed for use with the [tiredofit/docker-restic](https://github.com/tiredofit/docker-restic) Docker image.  
It simplifies the management of restic backup snapshots and restore operations by leveraging the container's unique environment variable naming scheme.

## 🚀 Features

- Uses a single numeric argument (e.g., `1`, `08`) to reference `BACKUPxx_` environment variables set by the Docker image
- Lists restic snapshots or performs targeted restores from snapshot IDs
- Supports optional `--host` and `--include` arguments for filtered output and/or restores

This script is particularly useful for users who structure multiple backup targets using tiredofit's container-based approach, and want a faster, cleaner way to inspect or restore data.

## 🧾 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).