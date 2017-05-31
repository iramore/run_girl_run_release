# Uncomment this line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘8.2’
# Uncomment this line if you're using Swift
 use_frameworks!

target 'run_run_run' do
pod 'BubbleTransition', '~> 2.0.0'
pod 'CVCalendar', '~> 1.4.1'
pod 'MotionAnimation'
pod 'ElasticTransition'
pod 'BMCustomTableView'
pod 'SAConfettiView'
pod 'Google-Mobile-Ads-SDK'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

