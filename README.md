# 🚀 Server Performance Monitor

A Production-Ready Linux Server Monitoring Tool built using **Bash Shell Scripting**.

This project monitors the overall health of a Linux server including CPU, Memory, Disk, Network, Docker, Security, Filesystem, and System Health. It can generate both **Text** and **HTML reports** for administrators.

---

# Features

✔ CPU Monitoring

✔ Memory Monitoring

✔ Disk Usage Monitoring

✔ Filesystem Usage

✔ Network Statistics

✔ Running Processes

✔ Top CPU Consuming Processes

✔ Top Memory Consuming Processes

✔ Docker Container Monitoring

✔ Security Checks

✔ Health Checks

✔ Log Generation

✔ HTML Report

✔ Text Report

✔ Easy Installation

---

# Project Structure

```
server-performance-monitor/
│
├── server-stats.sh          # Main script
├── config.conf              # Configuration
├── functions.sh             # Common reusable functions
├── logger.sh                # Logging functions
├── utils.sh                 # Utility functions
├── cpu.sh                   # CPU monitoring
├── memory.sh                # Memory monitoring
├── disk.sh                  # Disk monitoring
├── network.sh               # Network monitoring
├── docker.sh                # Docker monitoring
├── security.sh              # Security checks
├── filesystem.sh            # Filesystem monitoring
├── health-check.sh          # System health checks
├── report.sh                # Report generator
├── install.sh               # Installation script
│
├── reports/
│     ├── server-report.txt
│     └── server-report.html
│
├── logs/
│     └── server-monitor.log
│
│
├── README.md
├── LICENSE
└── .gitignore
```

---

# Prerequisites

Operating System

- Ubuntu
- Debian
- CentOS
- RHEL
- Amazon Linux
- Rocky Linux

Required Packages

```
bash
awk
grep
sed
curl
net-tools
sysstat
procps
lsof
docker (optional)

```

---

# Installation

Clone the repository

```bash
git clone https://github.com/yourusername/server-performance-monitor.git
```

Go to the project directory

```bash
cd server-performance-monitor
```

Give execute permissions

```bash
chmod +x *.sh
```

Run the installation

```bash
./install.sh
```

---

# Running the Project

Run all monitoring modules

```bash
./server-stats.sh
```

Generate Text Report

```bash
./report.sh text
```

Generate HTML Report

```bash
./report.sh html
```

Generate Both Reports

```bash
./report.sh all
```

---

# Monitoring Modules

## CPU

Displays

- CPU Usage
- CPU Load
- Load Average
- Number of Cores
- Top CPU Processes

---

## Memory

Displays

- Total Memory
- Used Memory
- Free Memory
- Swap Usage
- Memory Percentage

---

## Disk

Displays

- Disk Usage
- Mounted Partitions
- Inode Usage
- Disk Percentage

---

## Network

Displays

- IP Address
- Hostname
- Active Connections
- Listening Ports
- Network Interfaces
- Network Traffic

---

## Docker

Displays

- Docker Version
- Running Containers
- Images
- Container Status
- Docker Disk Usage

---

## Security

Displays

- Logged In Users
- Failed Login Attempts
- Open Ports
- Firewall Status
- SSH Status
- Running Services

---

## Filesystem

Displays

- Mounted Filesystems
- Disk Type
- Read Only Filesystems
- Large Files
- File Permissions

---

## Health Check

Displays

- System Uptime
- Load Average
- Zombie Processes
- Failed Services
- Running Services
- Memory Status
- Disk Status

---

# Reports

The project generates two reports.

## Text Report

```
reports/server-report.txt
```

## HTML Report

```
reports/server-report.html
```

The HTML report can be opened in any web browser.

---

# Logs

All execution logs are stored in

```
logs/server-monitor.log
```

---

# Configuration

Modify the following file

```
config.conf
```

Example

```bash
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=85
ENABLE_DOCKER=true

```

---

# Example Output

```
====================================
SERVER PERFORMANCE REPORT
====================================

Hostname : prod-server-01

CPU Usage : 24%

Memory Usage : 63%

Disk Usage : 58%

Docker Containers : 14

Kubernetes Nodes : 3

Network Status : Healthy

Security Status : OK

Health Check : PASSED
```

---

# Future Enhancements

- Email Alerts
- Slack Notifications
- Telegram Notifications
- SMS Alerts
- Prometheus Exporter
- Grafana Dashboard
- AWS CloudWatch Integration
- Azure Monitor Integration
- GCP Monitoring Integration
- PDF Report Generation
- Scheduled Monitoring using Cron
- Automatic Log Rotation

---

# Technologies Used

- Bash Shell Scripting
- Linux
- Docker
- HTML
- CSS

---

# Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push the branch.
5. Create a Pull Request.

---

# License

This project is licensed under the MIT License.

See the LICENSE file for details.

---

# Author

**K J D N Sai Charan**

Linux | DevOps | AWS | Docker | Shell Scripting

---

# Support

If you find this project useful, please consider giving it a ⭐ on GitHub.

Happy Monitoring! 🚀
