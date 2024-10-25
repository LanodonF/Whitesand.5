#!/bin/bash

# Script for auditing Linux systems for common security issues

# Function to check for failed SSH login attempts
check_failed_ssh() {
    echo "[+] Checking for failed SSH login attempts..."
    grep "Failed password" /var/log/auth.log 2>/dev/null || grep "Failed password" /var/log/secure 2>/dev/null
}

# Function to check for new/altered files
check_altered_files() {
    echo "[+] Checking for altered or new files in critical directories..."

    # Compare the current state of critical directories against the last audit snapshot (if any)
    critical_dirs=("/etc" "/bin" "/sbin" "/usr/bin" "/usr/sbin" "/var/www")

    for dir in "${critical_dirs[@]}"; do
        if [ ! -f /var/log/audit_snapshot.txt ]; then
            # If no previous snapshot exists, create one
            echo "Creating initial file audit snapshot..."
            find "${dir}" -type f -exec sha256sum {} \; > /var/log/audit_snapshot.txt
        else
            echo "Checking for changes in ${dir}..."
            find "${dir}" -type f -exec sha256sum {} \; | diff - /var/log/audit_snapshot.txt
        fi
    done
}

# Function to check for new users
check_new_users() {
    echo "[+] Checking for new user accounts..."

    # Compare the current /etc/passwd against the previous snapshot
    if [ ! -f /var/log/passwd_snapshot.txt ]; then
        echo "Creating initial user account snapshot..."
        cp /etc/passwd /var/log/passwd_snapshot.txt
    else
        echo "Checking for new users..."
        diff /etc/passwd /var/log/passwd_snapshot.txt
    fi
}

# Function to check for common bind/reverse shells
check_bind_reverse_shells() {
    echo "[+] Checking for common bind/reverse shells..."

    # Look for common shells using netstat and lsof
    netstat -tulnp | grep -E 'nc|perl|python|bash|sh|/dev/tcp'
    lsof -i -n -P | grep -E 'nc|perl|python|bash|sh|/dev/tcp'
}

# Function to check for known backdoors, RATs, and C2
check_backdoors_and_c2() {
    echo "[+] Checking for known backdoors, RATs, and C2 connections..."

    # Use ps to check for known malicious processes
    ps aux | grep -E 'meterpreter|mimikatz|powershell|nc|ncat|netcat|perl|python|bash|sh|reverse|bind|rat|c2'

    # Check for suspicious open connections
    netstat -an | grep -E '6667|6668|4444|4445|1337|1338|5555|9999|8374'
}

# Function to check for rootkits
check_rootkits() {
    echo "[+] Checking for rootkits..."

    # Install and run chkrootkit or rkhunter depending on system availability
    if [ -x "$(command -v chkrootkit)" ]; then
        sudo chkrootkit
    elif [ -x "$(command -v rkhunter)" ]; then
        sudo rkhunter --check
    else
        echo "chkrootkit or rkhunter not found. Installing chkrootkit..."
        if [ -f /etc/redhat-release ]; then
            sudo yum install -y chkrootkit
        elif [ -f /etc/lsb-release ]; then
            sudo apt install -y chkrootkit
        fi
        sudo chkrootkit
    fi
}

# Function to check for newly installed services
check_new_services() {
    echo "[+] Checking for newly installed or running services..."

    # Compare the current services with the previous snapshot
    if [ ! -f /var/log/services_snapshot.txt ]; then
        echo "Creating initial services snapshot..."
        systemctl list-units --type=service --all > /var/log/services_snapshot.txt
    else
        echo "Checking for new or altered services..."
        systemctl list-units --type=service --all | diff - /var/log/services_snapshot.txt
    fi
}

# Function to check for processes with network connections
check_network_connections() {
    echo "[+] Checking for processes with network connections..."

    # List all processes with open network connections
    lsof -i -n -P
}

# Main audit function
perform_audit() {
    echo "[+] Starting audit..."

    check_failed_ssh
    check_altered_files
    check_new_users
    check_bind_reverse_shells
    check_backdoors_and_c2
    check_rootkits
    check_new_services
    check_network_connections

    echo "[+] Audit complete!"
}

# Run the audit
perform_audit
