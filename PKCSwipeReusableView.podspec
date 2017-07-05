#
# Be sure to run `pod lib lint PKCSwipeReusableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PKCSwipeReusableView'
  s.version          = '0.1.1'
  s.summary          = 'ReusableView Swipe Button'
  s.description      = 'ReusableView Left, Right Swipe Button'
  s.homepage         = 'https://github.com/pikachu987/PKCSwipeReusableView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu77769@gmail.com' }
  s.source           = { :git => 'https://github.com/pikachu987/PKCSwipeReusableView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'PKCSwipeReusableView/Classes/**/*'
end
