# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

target 'StickerPocket' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
#   use_frameworks!

  # Pods for StickerPocket
  pod 'SDWebImage'
  pod 'DACircularProgress'
  pod 'pop'
  pod 'Colours'
  pod 'FMDB'
  pod 'Mantle'
  target 'MsgStickerPocket' do
      pod 'Mantle'
      pod 'FMDB'
      pod 'SDWebImage'
      pod 'Colours'
  end

  target 'StickerPocketTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'StickerPocketUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
