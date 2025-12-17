#!/bin/bash

echo "=== List SCSI hosts ==="
ls -d /sys/class/scsi_host/host* || exit 1

echo
echo "=== Start scanning SCSI hosts ==="
for host in /sys/class/scsi_host/host*; do
    echo "Scanning $host"
    echo "- - -" > "$host/scan"
done

echo
echo "=== Done ==="
