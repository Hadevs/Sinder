# Sinder

Sinder is framework with usefull functions for use cases, which we meeting in practice every day.

![Alt text](sinder_banner.png?raw=true "")
**Installation**
============
# CocoaPods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
<pre>
$ gem install cocoapods
</pre>
CocoaPods 1.1+ is required to build Sinder 1.0+.
To integrate Sinder into your Xcode project using CocoaPods, specify it in your Podfile:
<pre>
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Your Target Name' do
    pod 'Sinder'
end
</pre>
Then, run the following command:
<pre>
$ pod install
</pre>
