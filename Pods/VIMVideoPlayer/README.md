# VIMVideoPlayer

`VIMVideoPlayer` is a simple wrapper around the [AVPlayer](https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVPlayer_Class/index.html) and [AVPlayerLayer](https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVPlayerLayer_Class/index.html#//apple_ref/occ/cl/AVPlayerLayer) classes. 

## Setup

Add the `VIMVideoPlayerView` and `VIMVideoPlayer` classes to your project. 

Do this by including this repo as a git submodule or by using cocoapods:

```Ruby
# Add this to your podfile
target 'MyTarget' do
   pod 'VIMVideoPlayer', ‘{CURRENT_POD_VERSION}’
end
```

## Usage

Create a new `VIMVideoPlayerView` instance or set up an @IBOutlet:

```Swift

@IBOutlet weak var videoPlayerView: VIMVideoPlayerView!

...

override func viewDidLoad()
{
    // Configure the player as needed
    self.videoPlayerView.player.looping = true
    self.videoPlayerView.player.disableAirplay()
    self.videoPlayerView.setVideoFillMode(AVLayerVideoGravityResizeAspectFill)
    
    self.videoPlayerView.delegate = self
}

```

Play a video:

```Swift

// Using an NSURL

if let path = NSBundle.mainBundle().pathForResource("waterfall", ofType: "mp4")
{
    self.videoPlayerView.player.setURL(NSURL(fileURLWithPath: path))
}
else
{
    // Video file not found!
}

/* 
  Note: This must be a URL to an actual video resource (e.g. http://website.com/video.mp4 or .m3u8 etc.),
  It cannot be a URL to a web page (e.g. https://vimeo.com/67069182),
  See below for info on using VIMVideoPlayer to play Vimeo videos.
*/

// Using an AVPlayerItem

let playerItem: AVPlayerItem = ...
self.videoPlayerView.player.setPlayerItem(playerItem)
self.videoPlayerView.player.play()

// Or using an AVAsset

let asset: AVAsset = ...
self.videoPlayerView.player.setAsset(asset)
self.videoPlayerView.player.play()

```

Optionally implement the `VIMVideoPlayerViewDelegate` protocol methods:

```Swift

protocol VIMVideoPlayerViewDelegate 
{    
    optional func videoPlayerViewIsReadyToPlayVideo(videoPlayerView: VIMVideoPlayerView!)
    optional func videoPlayerViewDidReachEnd(videoPlayerView: VIMVideoPlayerView!)
    optional func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, timeDidChange cmTime: CMTime)
    optional func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, loadedTimeRangeDidChange duration: Float)
    optional func videoPlayerViewPlaybackBufferEmpty(videoPlayerView: VIMVideoPlayerView!)
    optional func videoPlayerViewPlaybackLikelyToKeepUp(videoPlayerView: VIMVideoPlayerView!)
    optional func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, didFailWithError error: NSError!)
}

```

See [`VIMVideoPlayer.h`](https://github.com/vimeo/VIMVideoPlayer/blob/master/VIMVideoPlayer/VIMVideoPlayer.h) for additional configuration options. 

## Playing Vimeo Videos

[Vimeo Pro](https://vimeo.com/pro) members can access playback URLs for Vimeo videos using the [Vimeo API](https://developer.vimeo.com/). Playback URLs are only included in the response object if the requesting account is a [Vimeo Pro](https://vimeo.com/pro) account.

If you have a [Vimeo Pro](https://vimeo.com/pro) account, when you make a request to the [Vimeo API](https://developer.vimeo.com/) for a video object the response object will contain a list of video `files`. These represent the various resolution video files available for this particular video. Each has a `link`. You can use the string value keyed to `link` to create an NSURL. You can pass this NSURL to VIMVideoPlayer for playback.

Check out [this](http://stackoverflow.com/questions/31960338/ios-vimvideoplayerview-cant-load-vimeo-videos) Stack Overflow question for additional info.

You can use the [Vimeo iOS SDK](https://github.com/vimeo/VIMNetworking) to interact with the [Vimeo API](https://developer.vimeo.com/). 

For full documentation on the Vimeo API go [here](https://developer.vimeo.com/).

## Found an Issue?

Please file it in the git [issue tracker](https://github.com/vimeo/VIMVideoPlayer/issues).

## Want to Contribute?

If you'd like to contribute, please follow our guidelines found in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

`VIMVideoPlayer` is available under the MIT license. See the [LICENSE](LICENSE.md) file for more info.

## Questions?

Tweet at us here: [@vimeoapi](https://twitter.com/vimeoapi).

Post on [Stackoverflow](http://stackoverflow.com/questions/tagged/vimeo-ios) with the tag `vimeo-ios`.

Get in touch [here](https://vimeo.com/help/contact).

Interested in working at Vimeo? We're [hiring](https://vimeo.com/jobs)!
