#!/bin/bash

#############################################
# FILESYSTEM CLEANUP / ARCHIVAL SCRIPT
#############################################

# Directories
SOURCE_DIR="/path/to/source_directory"
TARGET_DIR="/path/to/archive_directory"
LOG_FILE="/path/to/logs/fs_cleanup.log"

# Thresholds
SOURCE_THRESHOLD=85
TARGET_LIMIT=84

#############################################
# START LOG
#############################################

echo "========================================" >> $LOG_FILE
echo "Run Date: $(date)" >> $LOG_FILE

#############################################
# CHECK SOURCE FILESYSTEM USAGE
#############################################

SOURCE_USAGE=$(df -h /path/to/source_fs | awk 'NR==2 {print $5}' | sed 's/%//')

echo "Source Usage: ${SOURCE_USAGE}%" >> $LOG_FILE

if [ "$SOURCE_USAGE" -lt "$SOURCE_THRESHOLD" ]; then
    echo "No cleanup needed. Usage below threshold." >> $LOG_FILE
    exit 0
fi

#############################################
# CHECK TARGET DIRECTORY
#############################################

if [ ! -d "$TARGET_DIR" ]; then
    echo "ERROR: Target directory not found." >> $LOG_FILE
    exit 1
fi

#############################################
# CHECK TARGET FS USAGE
#############################################

TARGET_USAGE=$(df -h /path/to/target_fs | awk 'NR==2 {print $5}' | sed 's/%//')

echo "Target Usage: ${TARGET_USAGE}%" >> $LOG_FILE

if [ "$TARGET_USAGE" -ge "$TARGET_LIMIT" ]; then
    echo "ERROR: Target filesystem already above limit." >> $LOG_FILE
    exit 1
fi

echo "Script completed." >> $LOG_FILE
