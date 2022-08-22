# SDImage9PatchPNGCoder

[![CI Status](https://img.shields.io/travis/Captain Black/SDImage9PatchPNGCoder.svg?style=flat)](https://travis-ci.org/Captain Black/SDImage9PatchPNGCoder)
[![Version](https://img.shields.io/cocoapods/v/SDImage9PatchPNGCoder.svg?style=flat)](https://cocoapods.org/pods/SDImage9PatchPNGCoder)
[![License](https://img.shields.io/cocoapods/l/SDImage9PatchPNGCoder.svg?style=flat)](https://cocoapods.org/pods/SDImage9PatchPNGCoder)
[![Platform](https://img.shields.io/cocoapods/p/SDImage9PatchPNGCoder.svg?style=flat)](https://cocoapods.org/pods/SDImage9PatchPNGCoder)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SDImage9PatchPNGCoder is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SDImage9PatchPNGCoder'
```

## Usage
1. Remove SDImageAPNGCoder and add SDImage9PatchPNGCoder instead,
```objective-c
[SDImageCodersManager.sharedManager removeCoder:SDImageAPNGCoder.sharedCoder];
id<SDImageCoder> coder = [SDImage9PatchPNGCoder sharedCoder];
[SDImageCodersManager.sharedManager addCoder:coder];
```
2. Read the UIImage proptery sd_extendedObject.
```objective-c
__weak typeof(self) wself = self;
[SDWebImageManager.sharedManager loadImageWithURL:url
											options:0
											context:nil
											progress:nil
											completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
		__strong typeof(wself) self = wself;
		NSDictionary* dic = (NSDictionary*)image.sd_extendedObject;
		NSValue* value = dic[@"padding"];
		UIEdgeInsets insets = [value UIEdgeInsetsValue];
		image = [image resizableImageWithCapInsets:insets
									resizingMode:UIImageResizingModeStretch];
		self.chatBubbleImageView.image = image;
}];
```

## Author

Captain Black, captainblack.soul@gmail.com

## License

SDImage9PatchPNGCoder is available under the MIT license. See the LICENSE file for more info.
