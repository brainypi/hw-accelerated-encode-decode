#!/bin/bash 

# Hardware accelerated Encoding the input file in the given format.
# this uses Hardware VPU to encode mp4 file to h264/vp8 mkv file. 
# MP4 file --> Decode --> Encode --> H264/ VP8 MKH video file
# Do not use this code in production

usage() { 
        echo "Usage: $0 [-i {input file}] [-o {output file name}] [-v {video format h264/vp8}]" 1>&2 
        exit 1 
}


while getopts ":i:o:v:" o; do
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

if [ -z "${INPUT_FILE}" ] || [ -z "${OUTPUT_FILE}" ] || [ -z "${VIDEO_FORMAT}" ]; then
        usage
fi

if [[ ! -e ${INPUT_FILE} ]]; then 
        echo "Input file ${INPUT_FILE} does not exist. Aborting ..."
        exit 1
fi


# Check if the file is something other than mp4 
substr=".mp4"
if [[ $INPUT_FILE == *"$substr"* ]];
then
    echo "Starting encoding. Press Ctrl + C to stop encoding process."
else
    echo "ERROR: Invalid input file. The script only supports mp4 files."
    exit 1
fi

if [ ${VIDEO_FORMAT} == "h264" ] || [ ${VIDEO_FORMAT} == "H264" ] || [  ${VIDEO_FORMAT} == "h.264" ]; then

        gst-launch-1.0 filesrc location=${INPUT_FILE} ! qtdemux name=demux \
               demux.video_0 ! h264parse ! mppvideodec \
               ! videoconvert !  mpph264enc ! h264parse \
               ! matroskamux name=mixer ! filesink location=${OUTPUT_FILE} \
               demux.audio_0 ! queue ! decodebin \
               ! audioconvert ! audioresample quality=8 ! voaacenc bitrate=128000 ! mixer. > /dev/null 2>&1

elif [ ${VIDEO_FORMAT} == "vp8" ] || [ ${VIDEO_FORMAT} == "VP8" ]; then

        gst-launch-1.0 filesrc location=${INPUT_FILE} ! qtdemux name=demux \
                demux.video_0 ! h264parse ! mppvideodec \
                ! videoconvert ! mppvp8enc \
                ! matroskamux name=mixer ! filesink location=${OUTPUT_FILE} \
                demux.audio_0 ! queue ! decodebin \
                ! audioconvert ! audioresample quality=8 ! voaacenc bitrate=128000 ! mixer. > /dev/null 2>&1

fi

echo "Encoding complete." 
