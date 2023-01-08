#!/bin/bash 

# Script for Hardware accelerated decoding
# Given input mp4 file script uses MPP decoder to decode file to raw file. 
# MP4 file --> Decode --> RAW video
# Do not use this code in production

usage() { 
        echo "Usage: $0 [-i {input file}] [-o {output file name}]" 1>&2 
        exit 1 
}

while getopts ":i:o:v:w:h:" o; do
        case "${o}" in
                i)
                        INPUT_FILE=${OPTARG}
                        ;;
                o)
                        OUTPUT_FILE=${OPTARG}
                        ;;
                v)
                        VIDEO_FORMAT=${OPTARG}
                        ;;
                *)
                        usage
                        ;;
        esac
done
shift $((OPTIND-1))

if [ -z "${INPUT_FILE}" ] || [ -z "${OUTPUT_FILE}" ]; then
        usage
fi

if [[ ! -e ${INPUT_FILE} ]]; then 
        echo "Input file ${INPUT_FILE} does not exist. Aborting ..."
        exit 1
fi


# Check if the file is mp4
substr=".mp4"
if [[ $INPUT_FILE == *"$substr"* ]];
then
        echo "Starting encoding. Press Ctrl + C to stop decoding process."
else
        echo "ERROR: Invalid input file. The script only supports .mp4 files."
        exit 1
fi

echo "Decoded video will be stored in file ${OUTPUT_FILE}.video.raw"
echo "Decoded audio will be stored in file ${OUTPUT_FILE}.audio.raw"
echo "Note: RAW video files consume a lot of disk space. BrainyPi may soon run out of disk space."

gst-launch-1.0 filesrc location=${INPUT_FILE} ! qtdemux name=demux \
        demux.video_0 ! decodebin ! filesink location=${OUTPUT_FILE}.video.raw \
        demux.audio_0 ! decodebin ! filesink location=${OUTPUT_FILE}.audio.raw > /dev/null 2>&1

echo "Decoding complete." 
