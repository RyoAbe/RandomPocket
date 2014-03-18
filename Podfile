platform :ios, "7.0"

inhibit_all_warnings!

target :RandomPocket, :exclusive => true do
	pod 'PocketAPI'
	pod 'Toast', '~> 2.0'
	pod 'MRProgress', '~> 0.3'
	pod 'Appirater'
	pod 'PBWebViewController', '~> 0.0.1'
	pod 'MSCMoreOptionTableViewCell', '~> 1.1'
	pod 'SDWebImage'
	pod 'NJKScrollFullScreen'
	pod 'JASidePanels', '~> 1.3.2'
	pod 'CrittercismSDK', '~> 4.3.1'
#	pod 'iOSCommon', :path => '../iOSCommon'
	pod 'iOSCommon', :git => 'https://github.com/RyoAbe/iOSCommon.git', :branch => 'develop'
end

# Testing framework for Test target.
target :RandomPocketTests, :exclusive => true do
  pod 'Kiwi/XCTest'
  pod 'OCMock'
end
