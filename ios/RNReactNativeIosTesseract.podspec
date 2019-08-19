package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name           = "RNIosTesseract"
  s.version        = package['version']
  s.summary        = package['summary']
  s.description    = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.platform       = :ios, "7.0"
  s.source         = { :git => "https://github.com/ChVince/react-native-ios-tesseract.git", :tag => "master" }
  s.source_files   = "*.{h,m}"
  s.requires_arc   = true


  s.dependency     "React"
  s.dependency     'TesseractOCRiOS', '~> 4.0.0'
end
