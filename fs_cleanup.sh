{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww29200\viewh18460\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/bin/bash\
\
#############################################\
# FILESYSTEM CLEANUP / ARCHIVAL SCRIPT\
#############################################\
\
# Directories\
SOURCE_DIR="/path/to/source_directory"\
TARGET_DIR="/path/to/archive_directory"\
LOG_FILE="/path/to/logs/fs_cleanup.log"\
\
# Thresholds\
SOURCE_THRESHOLD=85      # Trigger cleanup\
TARGET_LIMIT=84          # Do not exceed in target FS\
\
#############################################\
# START LOG\
#############################################\
\
echo "========================================" >> $LOG_FILE\
echo "Run Date: $(date)" >> $LOG_FILE\
\
#############################################\
# CHECK SOURCE FILESYSTEM USAGE\
#############################################\
\
SOURCE_USAGE=$(df -h /path/to/source_fs | awk 'NR==2 \{print $5\}' | sed 's/%//')\
\
echo "Source Usage: $\{SOURCE_USAGE\}%" >> $LOG_FILE\
\
#############################################\
# EXIT IF BELOW THRESHOLD\
#############################################\
\
if [ "$SOURCE_USAGE" -lt "$SOURCE_THRESHOLD" ]; then\
    echo "No cleanup needed. Usage below threshold." >> $LOG_FILE\
    exit 0\
fi\
\
#############################################\
# CHECK TARGET DIRECTORY\
#############################################\
\
if [ ! -d "$TARGET_DIR" ]; then\
    echo "ERROR: Target directory not found." >> $LOG_FILE\
    exit 1\
fi\
\
#############################################\
# CHECK TARGET FS USAGE\
#############################################\
\
TARGET_USAGE=$(df -h /path/to/target_fs | awk 'NR==2 \{print $5\}' | sed 's/%//')\
\
echo "Target Usage: $\{TARGET_USAGE\}%" >> $LOG_FILE\
\
if [ "$TARGET_USAGE" -ge "$TARGET_LIMIT" ]; then\
    echo "ERROR: Target filesystem already above limit." >> $LOG_FILE\
    exit 1\
fi\
\
#############################################\
# FIND OLD FILES\
#############################################\
\
COUNT=$(find $SOURCE_DIR -type f -mtime +1 | wc -l)\
\
echo "Files found: $COUNT" >> $LOG_FILE\
\
#############################################\
# MOVE FILES WITH SAFETY CHECK\
#############################################\
\
find $SOURCE_DIR -type f -mtime +1 | while read file\
do\
    TARGET_USAGE=$(df -h /path/to/target_fs | awk 'NR==2 \{print $5\}' | sed 's/%//')\
\
    if [ "$TARGET_USAGE" -ge "$TARGET_LIMIT" ]; then\
        echo "Stopping: Target filesystem limit reached." >> $LOG_FILE\
        break\
    fi\
\
    mv "$file" "$TARGET_DIR"\
\
    echo "Moved: $file" >> $LOG_FILE\
done\
\
#############################################\
# FINAL STATUS\
#############################################\
\
echo "Script completed." >> $LOG_FILE\
echo "========================================" >> $LOG_FILE}