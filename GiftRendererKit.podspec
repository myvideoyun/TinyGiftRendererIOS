# coding: utf-8
#
#  Be sure to run `pod spec lint GiftRendererKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
Pod::Spec.new do |spec|
  spec.name         = "GiftRendererKit"
  spec.version      = "1.0.09"
  spec.summary      = "A lightweight gift renderer for live broadcasting with extremely tiny assets"
  spec.description  = <<-DESC "This Kit is used to render digital gift in live broadcasting. Usually image sequences are used to save the gift, for example png sequences. However they are too big and consume lots bandwidth."
                   DESC
  spec.homepage     = "https://github.com/myvideoyun/TinyGiftRendererIOS"
  spec.license      = "MIT"
  spec.author             = { "myvideoyun" => "developers@myvideoyun.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/myvideoyun/TinyGiftRendererIOS.git", :tag => "1.0.07" }
  spec.source_files  = "GiftRenderKit/**/*.{h,m,mm}"
  spec.exclude_files = ".DS_Store"
  spec.public_header_files = "GiftRenderKit/*.h"
  spec.library   = "c++", "z", "iconv"
  spec.vendored_libraries = "GiftRenderKit/**/*.a"
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  spec.dependency "FFmpeg"

end
