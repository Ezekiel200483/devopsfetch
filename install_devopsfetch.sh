#!/bin/bash

function print_header() {
    echo
    echo "==============================="
    echo "$1"
    echo "==============================="
}

print_header "Installing Dependencies"
sudo apt-get update
sudo apt-get install -y docker.io nginx

print_header "Copying devopsfetch Script"
sudo cp devopsfetch.sh /usr/local/bin/devopsfetch
sudo chmod +x /usr/local/bin/devopsfetch

print_header "Creating Systemd Service"
sudo tee /etc/systemd/system/devopsfetch.service > /dev/null <<EOF
[Unit]
Description=DevOpsFetch Monitoring Service
After=network.target

[Service]
ExecStart=/usr/local/bin/devopsfetch.sh -t "1 hour ago" "now"
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start the service
print_header "Starting and Enabling devopsfetch Service"
sudo systemctl daemon-reload
sudo systemctl enable devopsfetch
sudo systemctl start devopsfetch

print_header "Setting Up Log Rotation"
 <<EOF
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
EOF

print_header "Installation DONE 🙂"

