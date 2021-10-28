# VivoExtractor

Extracts raw video urls from any vivo.sx video, which allows you to download the video or show it in a native Video Player on your device. 

Written in 100% Swift. Works for iOS, macOS, watchOS, tvOS and Linux.


## Usage
Get video path from vivo page url:
```swift
let url = URL(string: "https://vivo.sx/b36ee9e324")!
VivoExtractor.extract(fromURL: url) { videoURL in
    // do stuff with retrieved videoURL
}
```
