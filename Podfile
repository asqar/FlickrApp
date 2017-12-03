workspace 'FlickrApp'
project 'FlickrApp.xcodeproj/'

platform :ios, '9.0'

use_frameworks!

pod 'SAMKeychain'
pod 'AFNetworking'  #, '~> 2.6.0' # There is a memory leak with AFNetworking >= 3.0
pod 'KVNProgress'
pod "MWPhotoBrowser", :podspec =>'https://raw.githubusercontent.com/moinku07/MWPhotoBrowser/master/MWPhotoBrowser.podspec'
pod 'FMMosaicLayout'

target "FlickrApp" do
  project 'FlickrApp.xcodeproj/'
  platform :ios, "9.0"

  pod 'Realm'
  pod 'RBQFetchedResultsController', :git => 'https://github.com/asqar/RBQFetchedResultsController.git'
  pod 'Realm+JSON', :git => 'https://github.com/asqar/Realm-JSON.git'

  pod 'SDWebImage'
  pod 'AFNetworking'
  pod 'SVPullToRefresh'

  pod 'FMMosaicLayout'

  pod 'Fabric'
  pod 'TwitterCore'
  pod 'Crashlytics'

  pod 'ReactiveCocoa'
  pod 'ReactiveViewModel'

end

target "FlickrAppUITests" do
  project 'FlickrApp.xcodeproj/'
  platform :ios, "9.0"

  pod 'Realm'
  pod 'RBQFetchedResultsController', :git => 'https://github.com/asqar/RBQFetchedResultsController.git'
  pod 'Realm+JSON', :git => 'https://github.com/asqar/Realm-JSON.git'

  pod 'SDWebImage'
  pod 'AFNetworking'
  pod 'SVPullToRefresh'

  pod 'FMMosaicLayout'

  pod 'Fabric'
  pod 'TwitterCore'
  pod 'Crashlytics'

  pod 'ReactiveCocoa'
  pod 'ReactiveViewModel'

end

target "FlickrAppTests" do
  project 'FlickrApp.xcodeproj/'
  platform :ios, "9.0"

  pod 'Realm'
  pod 'RBQFetchedResultsController', :git => 'https://github.com/asqar/RBQFetchedResultsController.git'
  pod 'Realm+JSON', :git => 'https://github.com/asqar/Realm-JSON.git'

  pod 'SDWebImage'
  pod 'AFNetworking'

  pod 'ReactiveCocoa'
  pod 'ReactiveViewModel'

  pod 'OCMock'

end
