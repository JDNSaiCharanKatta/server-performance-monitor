#!/usr/bin/env bash

###############################################################################
# Docker Monitoring Module
###############################################################################

docker_report() {

    log_section "DOCKER INFORMATION"

    # Check Docker installation
    if ! command -v docker >/dev/null 2>&1; then
        echo "Docker is not installed."
        return 0
    fi

    # Check Docker daemon
    if ! docker info >/dev/null 2>&1; then
        echo "Docker daemon is not running or permission denied."
        return 0
    fi

    echo
    echo "Docker Service"
    echo "--------------------------------------------------------------"

    if systemctl is-active --quiet docker 2>/dev/null; then
        echo "Status : Running"
    else
        echo "Status : Stopped"
    fi

    echo
    echo "Docker Version"
    echo "--------------------------------------------------------------"
    docker --version || true

    ###########################################################################
    # Containers
    ###########################################################################

    echo
    echo "Docker Containers"
    echo "--------------------------------------------------------------"

    total=$(docker ps -aq 2>/dev/null | wc -l || echo 0)
    running=$(docker ps -q 2>/dev/null | wc -l || echo 0)
    stopped=$(docker ps -aq --filter "status=exited" 2>/dev/null | wc -l || echo 0)

    printf "%-25s : %s\n" "Total Containers" "$total"
    printf "%-25s : %s\n" "Running" "$running"
    printf "%-25s : %s\n" "Stopped" "$stopped"

    echo

    if [ "$total" -gt 0 ]; then
        docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" || true
    else
        echo "No Docker containers found."
    fi

    ###########################################################################
    # Images
    ###########################################################################

    echo
    echo "Docker Images"
    echo "--------------------------------------------------------------"

    if [ "$(docker images -q 2>/dev/null | wc -l)" -gt 0 ]; then
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" || true
    else
        echo "No Docker images found."
    fi

    ###########################################################################
    # Volumes
    ###########################################################################

    echo
    echo "Docker Volumes"
    echo "--------------------------------------------------------------"

    docker volume ls 2>/dev/null || echo "No Docker volumes."

    ###########################################################################
    # Networks
    ###########################################################################

    echo
    echo "Docker Networks"
    echo "--------------------------------------------------------------"

    docker network ls 2>/dev/null || echo "No Docker networks."

    ###########################################################################
    # Disk Usage
    ###########################################################################

    echo
    echo "Docker Disk Usage"
    echo "--------------------------------------------------------------"

    docker system df 2>/dev/null || echo "Unable to retrieve Docker disk usage."

    ###########################################################################
    # Docker Info
    ###########################################################################

    echo
    echo "Docker Information"
    echo "--------------------------------------------------------------"

    docker info 2>/dev/null | awk '
    /Containers:/ ||
    /Running:/ ||
    /Paused:/ ||
    /Stopped:/ ||
    /Images:/ ||
    /Server Version/ ||
    /Storage Driver/ ||
    /Logging Driver/ ||
    /Cgroup Driver/ ||
    /Docker Root Dir/
    '

    ###########################################################################
    # Resource Usage
    ###########################################################################

    echo
    echo "Container Resource Usage"
    echo "--------------------------------------------------------------"

    if [ "$running" -gt 0 ]; then
        docker stats --no-stream \
        --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" || true
    else
        echo "No running containers."
    fi

    ###########################################################################
    # Restart Policies
    ###########################################################################

    echo
    echo "Restart Policies"
    echo "--------------------------------------------------------------"

    if [ "$total" -gt 0 ]; then
        docker ps -aq | while read -r id
        do
            name=$(docker inspect --format '{{.Name}}' "$id" 2>/dev/null | sed 's#^/##')
            policy=$(docker inspect --format '{{.HostConfig.RestartPolicy.Name}}' "$id" 2>/dev/null)

            printf "%-30s : %s\n" "$name" "$policy"
        done
    else
        echo "No containers found."
    fi

    ###########################################################################
    # Exited Containers
    ###########################################################################

    echo
    echo "Exited Containers"
    echo "--------------------------------------------------------------"

    if [ "$stopped" -gt 0 ]; then
        docker ps -a \
        --filter status=exited \
        --format "table {{.Names}}\t{{.Status}}" || true
    else
        echo "No exited containers."
    fi

    echo
}
