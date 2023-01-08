#include <iostream>
#include <string>
#include <stdio.h>

using namespace std;

int main(){
        // put your video name here
        string input="./samplevideo.mp4"; // video file
        string outvideoname = "test.mkv"; // output video name
        string cmd = "/opt/encode.sh -i "+input+" -o "+outvideoname+" -v h264";
        system(cmd.c_str());
        return 0;
}
 
