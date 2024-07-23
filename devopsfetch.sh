#!/bin/bash

# Function to show help
show_help() {
    cat << EOF
Usage: ${0##*/} [-h] [-p PORT] [-d CONTAINER] [-n DOMAIN] [-u USER] [-t START END]

Monitor and retrieve system information.

    -h               display this help and exit
    -p PORT          display active ports or details for the specified port
    -d CONTAINER     list Docker images and containers or details for the specified container
    -n DOMAIN        display Nginx domains/ports or config for the specified domain
    -u USER          list users and last login times or details for the specified user
    -t START END     display activities within the specified time range
EOF
}

# Function to display ports
display_ports() {
    local port=$1
    if [ -z "$port" ]; then
        echo "Active Ports and Services:"
        ss -tuln
    else
        echo "Details for Port $port:"
        ss -tuln | grep ":$port "
    fi
}

# Function to list Docker info
list_docker() {
    local container=$1
    if [ -z "$container" ]; then
        echo "Docker Images:"
        docker images
        echo "Docker Containers:"
        docker ps -a
    else
        echo "Details for Container $container:"
        docker inspect "$container"
    fi
}

# Function to display Nginx info
display_nginx() {
    local domain=$1
    if [ -z "$domain" ]; then
        echo "Nginx Domains and Ports:"
        grep -E 'server_name|listen' /etc/nginx/nginx.conf /etc/nginx/sites-enabled/* || true
    else
        echo "Configuration for Domain $domain:"
        grep -A 10 "server_name $domain;" /etc/nginx/nginx.conf /etc/nginx/sites-enabled/* || true
    fi
}

# Function to list users
list_users() {
    local user=$1
    if [ -z "$user" ]; then
        echo "Users and Last Login Times:"
        lastlog
    else
        echo "Details for User $user:"
        lastlog -u "$user"
    fi
}

# Function to display activities within a time range
display_time_range() {
    local start=$1
    local end=$2
    echo "Activities between $start and $end:"
    journalctl --since "$start" --until "$end"
}

# Parse command-line options
while getopts ":hp:d:n:u:t:" opt; do
    case $opt in
        h) show_help
           exit 0
           ;;
        p) display_ports "$OPTARG"
           exit 0
           ;;
        d) list_docker "$OPTARG"
           exit 0
           ;;
        n) display_nginx "$OPTARG"
           exit 0
           ;;
        u) list_users "$OPTARG"
           exit 0
           ;;
        t) display_time_range "$OPTARG" "$2"
           exit 0
           ;;
        *) show_help >&2
           exit 1
           ;;
    esac
done

# If no options were passed, show help
if [ $OPTIND -eq 1 ]; then
    show_help
fi

