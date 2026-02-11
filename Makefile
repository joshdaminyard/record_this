sim:
	open -a Simulator.app

updateios:
	cd ios && arch -x86_64 pod update

installios:
	cd ios && arch -x86_64 pod install

xcode:
	open ios/Runner.xcworkspace