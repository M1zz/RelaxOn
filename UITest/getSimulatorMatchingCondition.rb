# getSimulatorMatchingCondition.rb
# 주어진 조건에 해당하는 시뮬레이터의 고유 ID를 출력합니다.

# xcrun으로부터 받은 json을 parsing하기 위해 import합니다.
require "json"

# deviceName = ARGV[0]
deviceName = "iPhone SE (3rd generation)"
# runTime = ARGV[1]
runTime = "15-4"

# simulator list를 json형식으로 저장합니다.
json = JSON.parse(%x(xcrun simctl list 'devices' -j))
devices = json["devices"]["com.apple.CoreSimulator.SimRuntime.iOS-#{runTime}"]

if devices == nil
    puts "Error: 해당 OS를 만족하는 시뮬레이터가 설치되어 있지 않습니다"
else
    filteredDevices = devices.filter { |item| item["name"] == deviceName }

    if filteredDevices.empty?
        puts "Error: 해당 이름을 만족하는 시뮬레이터가 설치되어 있지 않습니다"
    else
        puts filteredDevices[0]["udid"]
    end
end
