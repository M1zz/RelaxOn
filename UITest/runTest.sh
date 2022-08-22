# runTest.sh
# Test를 실행하도록 하는 도구입니다.

# 마지막으로 실행했던 Test 결과가 남아있다면 제거합니다
rm -rf UITest/resultBundle
rm -rf UITest/resultBundle.xcresult

# Test Simulator Deivce
SIMULATOR_NAME="iPhone SE (3rd generation)"
# Test OS Version
SIMULATOR_OS_VERSION="15-4"
SIMULATOR_ID=$(ruby UITest/getSimulatorMatchingCondition.rb "$SIMULATOR_NAME" "$SIMULATOR_OS_VERSION")
BUNDLE_ID="com.leeo.RelaxOn"
BOOTED=$(xcrun simctl list 'devices' | grep "$SIMULATOR_NAME (" | head -1  | grep "Booted" -c)

open -a simulator

# Test를 위한 Simulator가 안 켜져 있으면 켭니다.
if [ $BOOTED -eq 0 ]
then
  xcrun simctl boot $SIMULATOR_ID
fi

# Test를 실행하기 전에, 기존에 설치된 App을 제거합니다.
xcrun simctl uninstall $SIMULATOR_ID $BUNDLE_ID

# Test를 실행합니다.
set -e -o pipefail 
xcodebuild test -project RelaxOn.xcodeproj \
  -scheme "RelaxOn" \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
  -resultBundlePath resultBundle
# -sdk iphonesimulator \

xcrun simctl shutdown $SIMULATOR_ID

# 테스트로 생긴 파일들을 이동시킵니다.
mv resultBundle UITest/
mv resultBundle.xcresult UITest/
