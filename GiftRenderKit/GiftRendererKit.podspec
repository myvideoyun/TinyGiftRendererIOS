# coding: utf-8
#
#  Be sure to run `pod spec lint GiftRendererKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
Pod::Spec.new do |spec|
  spec.name         = "GiftRendererKit"
  spec.version      = "1.2.1"
  spec.summary      = "A lightweight gift renderer for live broadcasting with extremely tiny assets"
  spec.description  = <<-DESC "This Kit is used to render digital gift in live broadcasting. Usually image sequences are used to save the gift, for example png sequences. However they are too big and consume lots bandwidth."
                   DESC
  spec.homepage     = "https://github.com/myvideoyun/TinyGiftRendererIOS"
  spec.license      = "MIT"
  spec.author             = { "myvideoyun" => "developers@myvideoyun.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/myvideoyun/TinyGiftRendererIOS.git", :tag => "1.2.0" }
  spec.source_files  = "GiftRenderKit", "GiftRenderKit/**/*.{h,m,mm}"
  spec.exclude_files = "GiftRenderKit/.DS_Store"
  spec.public_header_files = "GiftRenderKit/*.h"
  spec.library   = "c++", "z", "iconv"
  spec.vendored_libraries = "GiftRenderKit/**/*.a", "GiftRenderKit/GiftRenderLib/FFmpeg/*.a"
  spec.ios.framework = "AVFoundation", "VIdeoToolbox", "CoreVideo", "CoreMedia"
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64 i386' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64 i386' }
end
