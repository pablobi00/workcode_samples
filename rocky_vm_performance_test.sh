#!/bin/bash

##############################################################################
# Rocky Linux VM Performance Test Script
# Tests: CPU, Memory, Disk, Network, and System Load
##############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
YELLOW='\e[38;5;220m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# Output formatting functions
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

##############################################################################
# System Information
##############################################################################
print_header "System Information"
uname -a
print_info "Hostname: $(hostname)"
print_info "Kernel Release: $(uname -r)"

##############################################################################
# CPU Performance
##############################################################################
print_header "CPU Performance"

CPU_COUNT=$(nproc)
print_info "CPU Count: $CPU_COUNT"
print_info "CPU Model: $(cat /proc/cpuinfo | grep 'model name' | head -1 | cut -d: -f2 | xargs)"

# CPU Load
LOAD_1=$(cat /proc/loadavg | awk '{print $1}')
LOAD_5=$(cat /proc/loadavg | awk '{print $2}')
LOAD_15=$(cat /proc/loadavg | awk '{print $3}')
print_info "Load Average (1/5/15 min): $LOAD_1 / $LOAD_5 / $LOAD_15"

# Simple CPU benchmark - time a calculation
print_info "Running CPU benchmark (time a math loop)..."
START=$(date +%s%N)
for i in {1..1000000}; do
    result=$((i * 2 + 1))
done
END=$(date +%s%N)
ELAPSED=$(( (END - START) / 1000000 ))
print_success "CPU Benchmark completed in ${ELAPSED}ms"

##############################################################################
# Memory Performance
##############################################################################
print_header "Memory Performance"

TOTAL_MEM=$(free -h | grep Mem | awk '{print $2}')
USED_MEM=$(free -h | grep Mem | awk '{print $3}')
AVAIL_MEM=$(free -h | grep Mem | awk '{print $7}')
MEM_PERCENT=$(free | grep Mem | awk '{printf("%.2f", ($3/$2) * 100)}')

print_info "Total Memory: $TOTAL_MEM"
print_info "Used Memory: $USED_MEM"
print_info "Available Memory: $AVAIL_MEM"
print_info "Memory Usage: ${MEM_PERCENT}%"

# Swap info
TOTAL_SWAP=$(free -h | grep Swap | awk '{print $2}')
USED_SWAP=$(free -h | grep Swap | awk '{print $3}')
print_info "Total Swap: $TOTAL_SWAP"
print_info "Used Swap: $USED_SWAP"

##############################################################################
# Disk Performance
##############################################################################
print_header "Disk Performance"

print_info "Disk Space Usage:"
df -h / | tail -1 | awk '{printf("  Root Partition: %s used of %s (%.2f%%)\n", $3, $2, ($3/$2)*100)}'

# Disk I/O Performance - write speed test
print_info "Testing disk write speed (10MB)..."
TEST_FILE="/tmp/disk_test_$$.bin"
START=$(date +%s%N)
dd if=/dev/zero of="$TEST_FILE" bs=1M count=10 conv=fdatasync 2>/dev/null
END=$(date +%s%N)
ELAPSED_MS=$(( (END - START) / 1000000 ))
WRITE_SPEED=$(awk "BEGIN {printf \"%.2f\", (10 * 1024) / ($ELAPSED_MS / 1000)}")
print_success "Write Speed: ${WRITE_SPEED} MB/s (${ELAPSED_MS}ms)"
rm -f "$TEST_FILE"

# Disk I/O Performance - read speed test
print_info "Testing disk read speed (from cache)..."
TEST_FILE="/tmp/disk_test_$$.bin"
dd if=/dev/zero of="$TEST_FILE" bs=1M count=10 2>/dev/null
START=$(date +%s%N)
dd if="$TEST_FILE" of=/dev/null bs=1M 2>/dev/null
END=$(date +%s%N)
ELAPSED_MS=$(( (END - START) / 1000000 ))
READ_SPEED=$(awk "BEGIN {printf \"%.2f\", (10 * 1024) / ($ELAPSED_MS / 1000)}")
print_success "Read Speed: ${READ_SPEED} MB/s (${ELAPSED_MS}ms)"
rm -f "$TEST_FILE"

# Inode count
INODE_INFO=$(df -i / | tail -1 | awk '{printf("Inodes - Used: %s, Available: %s (%.2f%%)", $3, $2, ($3/$2)*100)}')
print_info "$INODE_INFO"

##############################################################################
# Network Performance
##############################################################################
print_header "Network Performance"

print_info "Network Interfaces:"
ip link show | grep "^[0-9]" | awk '{print "  " $2}' | sed 's/:$//'

print_info "IP Addresses:"
ip addr show | grep "inet " | awk '{print "  " $NF ": " $2}'

# Check network connectivity
if ping -c 1 8.8.8.8 &> /dev/null; then
    print_success "Internet connectivity: OK"
else
    print_info "Internet connectivity: Unavailable (may be expected in isolated VM)"
fi

##############################################################################
# Process Performance
##############################################################################
print_header "Process Performance"

PROCESS_COUNT=$(ps aux | wc -l)
print_info "Total Processes: $PROCESS_COUNT"

print_info "Top 5 Memory-consuming processes:"
ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf("  %s - %.2f%%\n", $11, $4)}'

print_info "Top 5 CPU-consuming processes:"
ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf("  %s - %.2f%%\n", $11, $3)}'

##############################################################################
# System Uptime
##############################################################################
print_header "System Uptime"
uptime

##############################################################################
# Package Manager Status (Rocky Linux)
##############################################################################
print_header "Package Manager Status"
if command -v dnf &> /dev/null; then
    print_info "DNF available"
    DNF_UPDATES=$(dnf check-update 2>/dev/null | grep -c "^[a-zA-Z]" || echo "0")
    print_info "Available updates: $DNF_UPDATES"
elif command -v yum &> /dev/null; then
    print_info "YUM available"
fi

##############################################################################
# System Services
##############################################################################
print_header "System Services Status"
systemctl is-active --quiet crond && print_success "Cron: Active" || print_error "Cron: Inactive"
systemctl is-active --quiet sshd && print_success "SSH: Active" || print_error "SSH: Inactive"
systemctl is-active --quiet systemd-resolved && print_success "DNS: Active" || print_error "DNS: Inactive"

##############################################################################
# Summary
##############################################################################
print_header "Performance Test Complete"
print_success "All tests completed successfully"
echo -e "\nTest completed at: $(date)"
echo "For more detailed analysis, review the output above."
