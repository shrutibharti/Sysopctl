#!/bin/bash

# Command name and version
COMMAND_NAME="sysopctl"
VERSION="v0.1.0"

# Function to show help
function show_help {
    echo "$COMMAND_NAME - System Operations Control"
    echo "Version: $VERSION"
    echo "Usage: $COMMAND_NAME [option]"
    echo "--help             Show this help message"
    echo "--version          Show version information"
    echo "service list       List all active services"
    echo "system load        View system load averages"
    echo "disk usage         Check disk usage statistics"
    echo "service start <service-name> Start a service"
    echo "service stop <service-name>  Stop a service"
    echo "process monitor    Monitor system processes"
    echo "logs analyze       Analyze system logs"
    echo "backup <path>     Backup system files"
}

# Function to show version
function show_version {
    echo "$COMMAND_NAME $VERSION"
}

# Main script logic
case $1 in
    --help)
        show_help
        ;;
    --version)
        show_version
        ;;
    service)
        case $2 in
            list)
                echo "Active Services:"
                systemctl list-units --type=service
                ;;
            start)
                if [ -z "$3" ]; then
                    echo "Please provide a service name."
                    exit 1
                fi
                sudo systemctl start "$3" && echo "Started service: $3"
                ;;
            stop)
                if [ -z "$3" ]; then
                    echo "Please provide a service name."
                    exit 1
                fi
                sudo systemctl stop "$3" && echo "Stopped service: $3"
                ;;
            *)
                echo "Unknown service command."
                show_help
                ;;
        esac
        ;;
    system)
        case $2 in
            load)
                echo "Current System Load Averages:"
                uptime
                ;;
            *)
                echo "Unknown system command."
                show_help
                ;;
        esac
        ;;
    disk)
        case $2 in
            usage)
                echo "Disk Usage Statistics:"
                df -h
                ;;
            *)
                echo "Unknown disk command."
                show_help
                ;;
        esac
        ;;
    process)
        case $2 in
            monitor)
                echo "Monitoring System Processes (Press CTRL+C to exit):"
                top
                ;;
            *)
                echo "Unknown process command."
                show_help
                ;;
        esac
        ;;
    logs)
        case $2 in
            analyze)
                echo "Recent Critical Log Entries:"
                journalctl -p crit -n 20
                ;;
            *)
                echo "Unknown logs command."
                show_help
                ;;
        esac
        ;;
    backup)
        if [ -z "$2" ]; then
            echo "Please provide a path to back up."
            exit 1
        fi
        # Backup using rsync
        rsync -a --progress "$2" "${2}.backup" && echo "Backup completed for $2"
        ;;
    *)
        echo "Unknown option. Use --help for usage."
        ;;
esac
