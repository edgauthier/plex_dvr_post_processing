# Overview

Based on: https://github.com/nebhead/PlexPostProc

This script is meant to run as a post processing script as part of the Plex DVR
feature. It will first try to extract any closed captions included with the
recording and then proceed to convert the recording to a 720p file that can be
direct streamed to an Apple TV or iOS device without requiring transcoding on
the server (and will also reduce the file size in the process). 

See script for more details on the parameters passed into ffmpeg to encode.

# Requirements

This script depends on the following components to already be installed:

- [ffmpeg][]
- [ccextractor][]

[ffmpeg]: https://ffmpeg.org 
[ccextractor]: https://www.ccextractor.org

# Usage

    process.sh <FILENAME>

