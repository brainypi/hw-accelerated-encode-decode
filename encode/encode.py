!/usr/bin/env python3

'''
Simple example to demonstrate HW accelerated encoding using python on BrainyPi.

Note: Do not use this code in production.
'''

import subprocess

# Put input video file name here
inputfile="./samplevideo.mp4"

# Put output video file name here
outvideoname = "test.mkv"

a= subprocess.call(['/opt/encode.sh','-i',inputfile,'-o',outvideoname,'-v','h264'])  
