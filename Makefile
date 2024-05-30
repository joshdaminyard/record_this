sim:
	open -a Simulator.app

updateios:
	arch -x86_64 pod update

installios:
	arch -x86_64 pod install

xcode:
	open ios/Runner.xcworkspace