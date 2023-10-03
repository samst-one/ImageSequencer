# ImageSequencer

[![A badge showing the current build status on bitrise. Please click to view more](https://app.bitrise.io/app/4e19a931-761f-4f2b-b360-dcf083ca551c/status.svg?token=zr81eI66uU886cB4Sn-1PQ&branch=main)](https://app.bitrise.io/app/4e19a931-761f-4f2b-b360-dcf083ca551c)

A framework for iOS that allows you to create videos from a selection of images. Developed by [Sam Stone](https://samst.one).

In use in production with [Lapsey](https://apps.apple.com/gb/app/lapsey/id6467548808).

## Overview

A well-tested, resource efficient package for creating videos from a selection of images.

The API can be found in the ``ImageSequencerController`` interface.

## Install

Go to **File > Swift Packages > Add Package Dependency** and add the following URL:

```
https://github.com/samst-one/ImageSequencer
```

## Usage

1. First we need to import the `ImageSequencer` into our project, we do this by importing the framework

```swift
import ImageSequencer
```

2. Next we need to create a `ImageSequencerController` object. The `ImageSequencerController` acts as the API for the package. We use the `ImageSequencerFactory` to do this. We also pass in the settings for the video we want to create. To create the `ImageSequencerController`, we do:

```swift
let outputUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(UUID().uuidString).mp4")

let renderSettings = RenderSettings(bitrate: 10000000,
                                    size: CGSize(width: 1920,
                                    height: 1080),
                                    fps: 24,
                                    outputUrl: outputUrl)

let controller = try? ImageSequencerFactory.make(settings: settings)
```

The `make` method has the ability to throw.

3. With the `controller`, we can now access the API. We first must start of some internal `ImageSequencer` processes before rendering. To do this, call:
```swift
controller.start()
```

4. When you have the images you want to render to a video, we can call the `render` function below.  A breakdown of the parameters are as follows.    

    - Parameters:
        - `images`: The collection of images you wish to render in URL format.
        - `didAddFrame`: A closure that returns a double representing the percentage of rendering completed.
        - `completion`: A closure thats called when all the images have been rendered out. It returns an optional `Error`.

So the code looks a bit like this:

```swift
controller?.render(images:  images) { percent in

} completion: { error in
                
}
```

5. Once the `completion` handler has been called without an error, you call the `finish()` method to produce the video. The video can be found at the output URL that was provided in the render settings.

```swift
controller?.finish {

}
```

6. Next we can start the camera. The callback is called when the camera has finished its start up process. This will show the preview in the `previewView`.

```swift
camera.start {
    // Do stuff here
}
```

## Putting it all together

In conclusion, to render out an sequence of images, use full code is below:

```swift
let outputUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(UUID().uuidString).mp4")

let renderSettings = RenderSettings(bitrate: 10000000,
                                    size: CGSize(width: 1920,
                                    height: 1080),
                                    fps: 24,
                                    outputUrl: outputUrl)

let controller = try? ImageSequencerFactory.make(settings: settings)
controller?.start()
    
controller?.render(images:  images) { percent in
    // Update the user on progress here.
} completion: { error in
    if error == nil {
        controller?.finish {
            // URL now available at output URL provided.
        }
    }
}
```

A sample app is included.
