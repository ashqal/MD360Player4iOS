# MD360Player4iOS
It is a lite library to render 360 degree panorama video for iOS.

## Preview
![ScreenShot](https://raw.githubusercontent.com/ashqal/MD360Player4iOS/master/screenshot.png)

## Pod
```
pod 'MD360Player4iOS', '~> 0.1.0'
```

## Release Node
**0.1.0**
* Motion Sensor
* Glass Mode(multi-screen)
* Easy to use
* Worked with AVPlayer.

## USAGE
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a AVPlayerItem
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.mURL];
    [self.player setPlayerItem:playerItem];
    [self.player play];
    
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveTouch];
    // Worked with AVPlayerItem
    [config asVideo:playerItem]; 
    [config setContainer:self view:self.view];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
}
```

## Supported Configuration
```objc
typedef NS_ENUM(NSInteger, MDModeInteractive) {
    MDModeInteractiveTouch,
    MDModeInteractiveMotion,
};

typedef NS_ENUM(NSInteger, MDModeDisplay) {
    MDModeDisplayNormal,
    MDModeDisplayGlass,
};
```

## Reference
* [HTY360Player(360 VR Player for iOS)](https://github.com/hanton/HTY360Player)
* [VideoPlayer-iOS](https://github.com/davidAgo4g/VideoPlayer-iOS)
* [iOS-OpenGLES-Stuff](https://github.com/jlamarche/iOS-OpenGLES-Stuff)
* [Moredoo.com](http://www.moredoo.com/)

# Android Version
[MD360Player4Android](https://github.com/ashqal/MD360Player4Android)

##LICENSE
```
Copyright 2016 Asha

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
