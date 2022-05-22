#!/bin/bash

#get the Cartesian x and y coodinates of a point that are passed as arguments
x=$1
y=$2

#convert the Cartesian coordinates to the corresponding polar coordinates
#compute radius and theta (in degrees) upto 5 decimal places
#note: theta should range from 0 to 360 degrees

echo "$x::$y" >> file
r=`echo  "((100000 * sqrt($x ^ 2 + $y ^2)) + 0.5) / 100000" | bc -l | grep -o '[^\.]*\.[0-9]\{5\}'`
if [ "$x" -eq 0 ]; then
   if [ $y -lt 0 ]; then
      theta=270.00000
   elif [ $y -gt 0 ]; then
      theta=90.00000
   else
      theta=0.00000
   fi
elif [ "$y" -eq 0 ]; then 
   if [ $x -lt 0 ]; then
      theta=180.00000
   elif [ $x -gt 0 ]; then
      theta=0.00000
   else
      theta=0.00000
   fi
else
   _y_=`echo $y | sed 's/-//g'`
   _x_=`echo $x | sed 's/-//g'`
   #echo "$_y_ $_x_"
   theta=`echo  "((100000 * (a( ${_y_} / ${_x_} ) * 180 ) / 3.14159265358979) + 0.5) / 100000 " | bc -l | grep -o '[^\.]*\.[0-9]\{5\}'`
   #echo "_$theta"
   if [ $x -lt 0 ]; then
      if [ $y -lt 0 ]; then
         theta=`echo "$theta + 180.00000" | bc -l`
      else
         theta=`echo "180.00000 - $theta" | bc -l`
      fi
   else
      if [ $y -lt 0 ]; then
         theta=`echo "360.00000 - $theta" | bc -l`
      else
         theta=$theta
      fi
   fi
fi

if [ $r = ".00000" ]; then
   r=0.00000
fi

 #echo $theta
 #if [ $(echo "$x < 0" | bc)  ]; then
 #   if [ $(echo "$theta < 0" | bc ) -eq 1 ]; then
 #   echo "check"
 #   theta=`echo "$theta + 180.00000" | bc -l`
 #   fi
 #fi
 #
 #if [ "$x" > 0 ]; then
 #   if [ "$y" < 0 ]; then
 #   theta=`echo "$theta + 360.00000" | bc -l`
 #   fi
 #fi

echo "${r}, $theta"
