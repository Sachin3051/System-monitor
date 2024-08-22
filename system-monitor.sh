#!/bin/bash

# Function to display CPU and memory usage for top 10 processes
cpu_memory_usage() {
    echo -e "\nTop 10 CPU and Memory consuming processes:"
    ps aux --sort=-%cpu | awk 'NR<=11{print $0}' | awk '{print $1, $2, $3, $4, $11}'
}

# Function to monitor network connections and packet drop
network_monitoring() {
    echo -e "\nNetwork Monitoring:"
    echo "Number of concurrent connections:"
    netstat -tun | grep ESTABLISHED | wc -l
    echo "Packet drop statistics:"
    netstat -i | grep -E "Iface|lo|enp|wlp"
}

# Function to display disk usage
disk_usage() {
    echo -e "\nDisk Usage:"
    df -h | grep -E '^/dev/'
}

# Function to display system load
system_load() {
    echo -e "\nSystem Load:"
    uptime | awk '{print "Load Average (1 min, 5 min, 15 min):", $8, $9, $10}'
}

# Function to display memory usage
memory_usage() {
    echo -e "\nMemory Usage:"
    free -h | awk 'NR==1 || NR==2{print $0}'
}

# Function to monitor active processes
process_monitoring() {
    echo -e "\nProcess Monitoring:"
    ps -e --no-headers | wc -l
}

# Function to monitor services
service_monitoring() {
    echo -e "\nService Monitoring (active, running):"
    systemctl list-units --type=service --state=running | grep '.service' | awk '{print $1}'
}

# Custom Dashboard function
dashboard() {
    clear
    while true; do
        echo -e "\n------------------ System Resource Dashboard ------------------"
        case $1 in
            cpu)
                cpu_memory_usage
                ;;
            memory)
                memory_usage
                ;;
            network)
                network_monitoring
                ;;
            disk)
                disk_usage
                ;;
            load)
                system_load
                ;;
            process)
                process_monitoring
                ;;
            service)
                service_monitoring
                ;;
            all|*)
                cpu_memory_usage
                memory_usage
                network_monitoring
                disk_usage
                system_load
                process_monitoring
                service_monitoring
                ;;
        esac
        sleep 5
        clear
    done
}

# Help function
help_menu() {
    echo -e "\nUsage: $0 [OPTION]"
    echo -e "Options:"
    echo -e "  cpu       Display CPU and Memory usage"
    echo -e "  memory    Display Memory usage"
    echo -e "  network   Display Network Monitoring"
    echo -e "  disk      Display Disk Usage"
    echo -e "  load      Display System Load"
    echo -e "  process   Display Process Monitoring"
    echo -e "  service   Display Service Monitoring"
    echo -e "  all       Display all monitoring in a custom dashboard (default)"
    echo -e "  help      Display this help and exit"
}

# Main script execution
if [[ $# -eq 0 || $1 == "all" ]]; then
    dashboard all
elif [[ $1 == "cpu" || $1 == "memory" || $1 == "network" || $1 == "disk" || $1 == "load" || $1 == "process" || $1 == "service" ]]; then
    dashboard $1
elif [[ $1 == "help" ]]; then
    help_menu
else
    echo "Invalid option. Use 'help' for usage information."
    exit 1
fi
