#include <iostream>
#include <string>
#include <stdio.h>

using namespace std;

int main(){
        // put your video name here
        string videoname="samplevideo.mp4";
        string cmd = "/opt/decode.sh -i "+videoname+" -o ./outputfile1";
        system(cmd.c_str());
        return 0;
}
 
