# 0. clean build directories
rm -rf derived_data TMDBServices.framework build
# 1.1 Build framework for simulator
xcodebuild clean build -workspace TMDBServices.xcworkspace -scheme TMDBServices -derivedDataPath derived_data -configuration Release -arch x86_64 -sdk iphonesimulator BUILD_LIBRARY_FOR_DISTRIBUTION=YES
# 1.2 Build framework for iOS devices
xcodebuild build -workspace TMDBServices.xcworkspace -scheme TMDBServices -derivedDataPath derived_data -configuration Release -arch arm64 -sdk iphoneos BUILD_LIBRARY_FOR_DISTRIBUTION=YES
# 2.1 Create universal framework
mkdir TMDBServices.framework
cp -r derived_data/Build/Products/Release-iphoneos/TMDBServices.framework/ TMDBServices.framework/
# 2.2 Create binary compatible with devices and simulators
lipo -create \
  derived_data/Build/Products/Release-iphoneos/TMDBServices.framework/TMDBServices \
  derived_data/Build/Products/Release-iphonesimulator/TMDBServices.framework/TMDBServices \
  -output TMDBServices.framework/TMDBServices
# 2.3 Copy simulator Swift public interface to universal framework - Not working
cp -r derived_data/Build/Products/Release-iphonesimulator/TMDBServices.framework/Modules/TMDBServices.swiftmodule/* TMDBServices.framework/Modules/TMDBServices.swiftmodule/