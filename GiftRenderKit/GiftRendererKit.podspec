# coding: utf-8
#
#  Be sure to run `pod spec lint GiftRendererKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
Pod::Spec.new do |spec|
  spec.name         = "GiftRendererKit"
  spec.version      = "1.0.0"
  spec.summary      = "A lightweight gift renderer for live broadcasting with extremely tiny assets"
  spec.description  = <<-DESC "This Kit is used to render digital gift in live broadcasting. Usually image sequences are used to save the gift, for example png sequences. However they are too big and consume lots bandwidth."
                   DESC
  spec.homepage     = "https://github.com/myvideoyun/TinyGiftRendererIOS"
  spec.license      = "MIT"
  spec.author             = { "myvideoyun" => "developers@myvideoyun.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/myvideoyun/TinyGiftRendererIOS.git", :tag => "1.0.0" }
  spec.source_files  = "GiftRenderKit", "GiftRenderKit/**/*.{h,m}"
  spec.exclude_files = "GiftRenderKit/.DS_Store"
  spec.public_header_files = "GiftRenderKit/*.h"
end