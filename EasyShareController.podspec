Pod::Spec.new do |s|
    s.name             = "EasyShareController"
    s.version          = "1.0.0"
    s.summary          = "一款让社交分享变得简单的视图控制器"
    s.description      = <<-DESC
    一款让社交分享变得简单的视图控制器
    DESC
    s.homepage         = "http://www.lessney.com"
    s.license          = 'MIT'
    s.author           = {"pcjbird" => "pcjbird@hotmail.com"}
    s.source           = {:git => "https://github.com/pcjbird/EasyShareController.git", :tag => s.version.to_s}
    s.social_media_url = 'https://github.com/pcjbird/EasyShareController'
    s.requires_arc     = true
#s.documentation_url = ''
#s.screenshot       = ''

    s.platform         = :ios, '8.0'
    s.frameworks       = 'Foundation', 'UIKit'
#s.preserve_paths   = ''
    s.source_files     = 'EasyShareController/*.{h,m}','EasyShareController/EasyShareSocialButton/*.{h,m}'
    s.public_header_files = 'EasyShareController/*.{h}'


    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

end
