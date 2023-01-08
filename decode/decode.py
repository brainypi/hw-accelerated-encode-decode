#!/usr/bin/env python3

'''
Simple example to demonstrate HW accelerated decoding using python on BrainyPi.

Note: Do not use this code in production.
'''

import subprocess

# Put input video name here
videoname = "samplevideo.mp4"

a= subprocess.call(['/opt/decode.sh','-i',videoname,'-o','./outputfile1']) 
