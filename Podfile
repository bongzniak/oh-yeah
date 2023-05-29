platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/sdk-banuba/banuba-sdk-podspecs.git'

workspace 'oh-yeah.xcworkspace'
project 'Projects/Cocoapods/Cocoapods.xcodeproj'
        
target 'Cocoapods' do
  project 'Projects/Cocoapods/Cocoapods.xcodeproj'

  pod 'BNBSdkApi', '> 1'
  pod 'BNBBackground', '> 1'
  pod 'BNBFaceTracker', '> 1'
end