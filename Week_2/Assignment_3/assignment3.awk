#!/bin/awk -f

#cmd = "cp -rf utilities mydir";
#system(cmd);
#{print $0 >"/dev/stderr"}
BEGIN {print "Value\tSensorNumber\t"; FS=","; RS="!"} 
NF!=1 {print $1"\t"$2}
#NF!=1 && !visited[$2]++ {print $2"\t"$1}
#NF!=1 {sensordata[$2]=$1}
#END {  for (i in sensordata) {
#           print sensordata[i]"\t"i;
#       }
#    }
#NF!=1 {sensordata[$2]=$1; 
#         #if ( !($2 in linenumber)) {
#            linenumber[$2]=NR;
#         #}
#       }
#END { 
#      for (i in sensordata) {
#          min = 10000;
#          for ( j in linenumber ) {
#              if ( linenumber[j] < min && !(j in printed)) {
#                 #print j","linenumber[j];
#                 sensor = j;
#                 min = linenumber[j];
#              }
#          }
#          print sensordata[sensor]"\t"sensor;
#          printed[sensor] = 1;
#      }
#    }
