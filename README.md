# MD360Player4iOS
It is a lite library to render 360 degree panorama video for iOS.

## Preview
![ScreenShot](https://raw.githubusercontent.com/ashqal/MD360Player4iOS/master/screenshot.png)
![ScreenShot](https://raw.githubusercontent.com/ashqal/MD360Player4iOS/master/screenshot2.png)
</br>
[Raw 360 Panorama Video](http://d8d913s460fub.cloudfront.net/krpanocloud/video/airpano/video-1920x960a.mp4)

## Pod
```
pod 'MD360Player4iOS', '~> 0.3.1'
```

## Release Node
**0.3.0**
* Fix crucial bug(e.g. crash, black screen).
* Custom director factory support.
* Better way to render multi screen.
* Add motion with touch strategy.
* Add 360 bitmap support.

**0.2.0**
* Pinch gesture supported.

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
    
    [config asVideo:playerItem];
    [config setContainer:self view:self.view];
    
    // optional
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveMotion];
    [config pinchEnabled:true];
    [config setDirectorFactory:self];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
}
```

## Supported Configuration
```objc
typedef NS_ENUM(NSInteger, MDModeInteractive) {
    MDModeInteractiveTouch,
    MDModeInteractiveMotion,
    MDModeInteractiveMotionWithTouch,
};

typedef NS_ENUM(NSInteger, MDModeDisplay) {
    MDModeDisplayNormal,
    MDModeDisplayGlass,
};
```

## Enabled Pinch Gesture
```objc
/////////////////////////////////////////////////////// MDVRLibrary
MDVRConfiguration* config = [MDVRLibrary createConfig];

...
[config pinchEnabled:true];

self.vrLibrary = [config build];
/////////////////////////////////////////////////////// MDVRLibrary
```

## Custom Director Factory
```objc
@interface VideoPlayerViewController ()<MD360DirectorFactory>
@end

@implementation VideoPlayerViewController
...
- (void) initPlayer{
   	...
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
   	...
    [config setDirectorFactory:self]; // pass in the custom factory
    ...
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
}

// implement the MD360DirectorFactory protocol here.
- (MD360Director*) createDirector:(int) index{
    MD360Director* director = [[MD360Director alloc]init];
    switch (index) {
        case 1:
            [director setEyeX:-2.0f];
            [director setLookX:-2.0f];
            break;
        default:
            break;
    }
    return director;
}
...
@end

```

## 360 Bitmap Support
```objc
@interface BitmapPlayerViewController ()<IMDImageProvider>

@end

@implementation BitmapPlayerViewController

...

- (void) initPlayer{
    ...
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    ...
    [config asImage:self];
    ...
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
   
}

// implement the IMDImageProvider protocol here.
-(void) onProvideImage:(id<TextureCallback>)callback{
    //
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:self.mURL options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                NSLog(@"progress:%ld/%ld",receivedSize,expectedSize);
                                // progression tracking code
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if ( image && finished) {
                                   // do something with image
                                   if ([callback respondsToSelector:@selector(texture:)]) {
                                       [callback texture:image];
                                   }
                               }
                           }];
    
    
}

@end
```
See [BitmapPlayerViewController.m](https://github.com/ashqal/MD360Player4iOS/blob/master/MD360Player4iOS/BitmapPlayerViewController.m)

## Reference
* [HTY360Player(360 VR Player for iOS)](https://github.com/hanton/HTY360Player)
* [VideoPlayer-iOS](https://github.com/davidAgo4g/VideoPlayer-iOS)
* [iOS-OpenGLES-Stuff](https://github.com/jlamarche/iOS-OpenGLES-Stuff)
* [Thanks to vimeo/VIMVideoPlayer](https://github.com/vimeo/VIMVideoPlayer)
* [Moredoo.com](http://www.moredoo.com/)


# Android Version
[MD360Player4Android](https://github.com/ashqal/MD360Player4Android)

## Feedback
* Open a new issue
* or ashqalcn@gmail.com
* or QQ Group<br/>
![QQ Group](https://cloud.githubusercontent.com/assets/5126517/15381968/5a0e56a2-1db7-11e6-986e-462d96dd5e02.jpeg)

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
