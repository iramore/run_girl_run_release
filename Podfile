# Uncomment this line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘9.3’
# Uncomment this line if you're using Swift
 use_frameworks!

target 'run_run_run' do
pod 'CVCalendar', '~> 1.4.0’
pod 'MotionAnimation', :git => 'https://github.com/lkzhao/MotionAnimation.git', :branch => 'swift3'
pod 'ElasticTransition', :git => 'https://github.com/lkzhao/ElasticTransition.git', :branch => 'swift3'
pod 'BMCustomTableView'
pod 'SAConfettiView'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

