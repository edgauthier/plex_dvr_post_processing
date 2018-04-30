#!/bin/bash

#****************************************************************************** 
#****************************************************************************** 
#
#            Plex DVR Post Processing w/ffmpeg (H.264) Script
#
#****************************************************************************** 
#****************************************************************************** 
#  
#  Version: 1.0
#
#  Pre-requisites: 
#     ffmpeg
#     ccextractor
#
#  Usage: 
#     'process.sh <FILENAME>'
#
#  Description:
#      Extracts the closed captions from the source file, and then 
#      re-encodes the file with subtitles at 720p
#
#      The input file is replaced in preparation for Plex to move it
#      to the appropriate location
#
#****************************************************************************** 

check_errs()
{
    # Function. Parameter 1 is the return code
    # Para. 2 is text to display on failure
    if [ "${1}" -ne "0" ]; then
        echo "ERROR # ${1} : ${2}"
        exit ${1}
    fi
}

if [ ! -z "$1" ]; then 
    
    FILENAME=$1 	# Filename of input original file

    TEMPFILENAME="$(mktemp).mkv"  # Temporary File for transcoding
    check_errs $? "Failed to create temporary file: $TEMPFILENAME"

    SRTFILENAME="$(mktemp).srt"  # Temp file for extracted subtitles
    check_errs $? "Failed to create temporary file: $SRTFILENAME"

    echo "********************************************************" 
    echo "Extracting Closed Captions as SRT subtitles" 
    echo "********************************************************" 

    ccextractor "$FILENAME" -o "$SRTFILENAME"

    echo "********************************************************" 
    echo "Starting Transcoding: Converting to H.264 w/ffmpeg @720p" 
    echo "********************************************************" 

    ffmpeg -i "$FILENAME" -itsoffset 0.5 -i "$SRTFILENAME" \
        -s hd720 -c:v libx264 -preset veryfast -vf yadif -b:v 3M -level 4.0 \
        -c:a copy \
        -c:s srt -metadata:s:s:0 language=ENG \
        "$TEMPFILENAME"
    check_errs $? "Failed to convert using ffmepg"

    echo "********************************************************" 
    echo "Cleanup / Copy $TEMPFILENAME to $FILENAME" 
    echo "********************************************************" 

    rm -f "$FILENAME" # Delete original
    rm -f "$SRTFILENAME" # Delete the SRT file
    mv -f "$TEMPFILENAME" "${FILENAME%.ts}.mkv" # Move completed temp to original filename

    echo "********************************************************" 
    echo "Done.  Success!" 
    echo "********************************************************" 
else
    echo "********************************************************" 
    echo "Plex DVR Post Processing"
    echo "Usage: $0 <FILENAME>" 
    echo "********************************************************" 
fi

