#
# Be sure to run `pod lib lint CLMNetworking.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CLMNetworking"
  s.version          = "0.2.0"
  s.summary          = "A short description of CLMNetworking."
  s.description      = <<-DESC
                       An optional longer description of CLMNetworking

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/hirai-yuki/CLMNetworking"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "hirai.yuki" => "hirai.yuki@classmethod.jp" }
  s.source           = { :git => "https://github.com/hirai-yuki/CLMNetworking.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/yutu0614'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  # s.resource_bundles = {
  #   'CLMNetworking' => ['Pod/Assets/*.png']
  # }

  s.dependency 'Bolts', '~> 1.1.3'
  s.dependency 'AFNetworking', '~> 2.5.1'
  s.dependency 'AFOAuth2Manager', '~> 2.0.0'
end
