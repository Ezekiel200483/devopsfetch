# DevOpsFetch

DevOpsFetch is a tool designed to collect and display system information, including active ports, user logins, Nginx configurations, Docker images, and container statuses. It also supports continuous monitoring and logging using a systemd service.

## Features

- **Display Active Ports**: Show all active ports and services, or details for a specific port.
- **Docker Information**: List all Docker images and containers, or details for a specific container.
- **Nginx Configuration**: Display Nginx domains and their ports, or detailed configuration for a specific domain.
- **User Logins**: List all users and their last login times, or details for a specific user.
- **Time Range Activities**: Display activities within a specified time range.

## Installation

### Prerequisites

- Ubuntu or similar Linux distribution
- `docker.io`
- `nginx`

### Steps

1. **Clone the Repository**

    ```bash
    git clone <repository-url> devopsfetch
    cd devopsfetch
    ```

2. **Run the Installation Script**

    ```bash
    sudo bash install_devopsfetch.sh
    ```

    This script will:
    - Install necessary dependencies (`docker.io` and `nginx`).
    - Copy the `devopsfetch.sh` script to `/usr/local/bin/` and make it executable.
    - Create and enable a systemd service to run `devopsfetch` continuously.
    - Set up log rotation for the `devopsfetch` logs.

## Usage

The `devopsfetch` script supports several options to retrieve system information.

### Command Line Options

- `-p [PORT]`: Display active ports. If a port number is provided, show details for that port.
- `-d [CONTAINER]`: List Docker images and containers. If a container name is provided, show details for that container.
- `-n [DOMAIN]`: Display Nginx domains/ports. If a domain is provided, show the configuration for that domain.
- `-u [USER]`: List users and their last login times. If a username is provided, show details for that user.
- `-t [START] [END]`: Display activities within the specified time range.
- `-h, --help`: Show the help message.

### Examples

- **List all Docker images and containers**:
    ```bash
    devopsfetch.sh -d
    ```

- **Show details for the `hello-world` container**:
    ```bash
    devopsfetch.sh -d hello-world
    ```

- **Show all active ports**:
    ```bash
    devopsfetch.sh -p
    ```

- **Show details for port 80**:
    ```bash
    devopsfetch.sh -p 80
    ```

- **List all users and their last login times**:
    ```bash
    devopsfetch.sh -u
    ```

- **Show details for user `username`**:
    ```bash
    devopsfetch.sh -u username
    ```

- **Display activities from "1 hour ago" to "now"**:
    ```bash
    devopsfetch.sh -t "1 hour ago" "now"
    ```

## Systemd Service

The `devopsfetch` service is set up to run continuously, monitoring system activities.

### Check Service Status

```bash
sudo systemctl status devopsfetch

## Start  Service
sudo systemctl start devopsfetch

- Log Rotation
Log rotation is configured for the devopsfetch logs to ensure they do not consume too much disk space.

Log Rotation Configuration
Logs are rotated daily, compressed, and kept for 7 days.

Configuration file: /etc/logrotate.d/devopsfetch

/usr/local/bin/devopsfetch.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0640 root root
    postrotate
        systemctl restart devopsfetch > /dev/null 2>/dev/null || true
    endscript
}


Conclusion
DevOpsFetch is a comprehensive tool for monitoring and retrieving system information. By following the installation steps and using the provided commands, you can easily keep track of various system activities and configurations.

