#!/bin/bash

# open -a Simulator --args -CurrentDeviceUDID 56B8CC72-81AF-453A-9902-3A102BE84E25

# Test Code
# xcodebuild test -scheme "RelaxOn" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 8,OS=15.4'

# xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+' | awk '{$1=$1;print}' | sed -e "s/ Simulator$//" | sed -e "s/i/\"i/" | sed -e "s/$/\"/"

# xcodebuild test -scheme "RelaxOn" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 8,OS=15.4'
rm UITest/simulator.txt
xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+' | awk '{$1=$1;print}' | sed -e "s/ Simulator$//" >> UITest/simulator.txt

SIMULATOR_ARRAY=()
while read simulator; do
	echo $simulator
        SIMULATOR="$(echo $SIMULATOR_LIST_STRING | cut -d'\n')"
        SIMULATOR_ARRAY+=$SIMULATOR
        # xcodebuild test -scheme "RelaxOn" -sdk iphonesimulator -destination "platform=iOS Simulator,name=$simulator,OS=15.4"
done < UITest/simulator.txt

# Get Simulator List
#SIMULATOR_LIST_STRING=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+' | awk '{$1=$1;print}' | sed -e "s/ Simulator$//" | sed -e "s/$/\":/" | sed -e "s/i/\"i/" )
SIMULATOR_LIST_STRING=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+' | awk '{$1=$1;print}' | sed -e "s/ Simulator$//" | sed -e "s/$/:/" )
#SIMULATOR_LIST= $(echo $SIMULATOR_LIST | cut -d'\n')

# for var in "${SIMULATOR_LIST[@]}"
# do
#   echo "{$var}Hello"
# done
# echo $SIMULATOR_LIST_STRING
#echo $SIMULATOR_LIST_STRING | cut -d ':' -f1

#echo $SIMULATOR_LIST

#SIMULATOR_ARRAY=()
#SIMULATOR=""
#for index in {1..25}
#do
#  SIMULATOR="$(echo $SIMULATOR_LIST_STRING | cut -d ':' -f$index)"
#  echo "Cut Value: $SIMULATOR"
#  SIMULATOR_ARRAY+="$SIMULATOR"
#done

# echo $SIMULATOR_STRING | cut -d ':' -f100
# echo "Slice End"
#echo $SIMULATOR_ARRAY
#for var in ${SIMULATOR_ARRAY[@]}
#do
#  echo $var
#done

result=`echo "${SIMULATOR_ARRAY[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '`
echo $result

