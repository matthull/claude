#!/bin/bash
# Check full Waydroid and ADB status
# Usage: status.sh

echo "=== Waydroid Status ==="
waydroid status 2>&1

echo ""
echo "=== ADB Devices ==="
adb devices 2>&1

echo ""
echo "=== Network Status ==="
echo "Host bridge (waydroid0):"
ip addr show waydroid0 2>/dev/null | grep -E "inet |state" || echo "  waydroid0 not found"

echo ""
echo "Android network:"
sudo waydroid shell -- ip addr show eth0 2>/dev/null | grep -E "inet |state" || echo "  Could not check Android network"

echo ""
echo "=== Connectivity Test ==="
if ping -c 1 -W 1 192.168.240.112 &>/dev/null; then
    echo "Host -> Android: OK"
else
    echo "Host -> Android: FAILED"
fi

echo ""
echo "=== Expo/Metro Status ==="
if curl -s --connect-timeout 1 http://localhost:8081/status &>/dev/null; then
    echo "Metro bundler: RUNNING on port 8081"
else
    echo "Metro bundler: NOT RUNNING"
fi
