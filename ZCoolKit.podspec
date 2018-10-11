Pod::Spec.new do |s|
  s.name             = 'ZCoolKit'
  s.version          = '0.3'
  s.summary          = 'This is my amazing kit.'
  s.homepage         = 'https://github.com/zframeworkdev/ZCoolKit'
  s.swift_version    = '4.1'
  s.author           = { 'Zaldy Bughaw' => 'zframeworkdev@gmail.com' }
  s.description      = <<-DESC
    This is a drop-in iOS component that allows apps to force users to upgrade to new versions of an app by checking for the latest version in the AppStore or via a configuration in Firebase.
                   DESC

  # Compatibility & Sources
  s.platform     = :ios, "8.0"
  s.license	 = { :type => 'MIT', :file => 'LICENSE' }
  s.source	 = { :git => 'https://github.com/zframeworkdev/ZCoolKit.git', :tag => s.version.to_s }
  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
end
