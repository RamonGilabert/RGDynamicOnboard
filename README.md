## RGDynamicOnboard

A nicely dynamic slideshow to present whatever you want, just add an image, some text and choose one of the animations, RGDynamicOnboard will take care of the rest. There are multiple ways to customize your slide show, add static images, images that go from a page to another, add text, choose the font and some colors and, with just 5 lines of code, you have a fully responsive slideshow!

## Featuring

- As easy as entering a string and choosing some animations.
- For all devices, calculated sizes dinamically.
- Multiple options of customization.
- Do more, write less.
- Animations calculated dinamically.
- Animations going left or right.
- Not all pages loaded at the same time, less memory space.

## Usage

Import the main file into your Xcode project or use Cocoapods to install the pod.

### Create a simple walkthrough

```objc
self.mainSlideView = [[RGDynamicOnboard alloc] initFullscreenWithNumberOfSlides:3 andPageControl:YES inView:self.view];
```

### Customize it, add images, some text

```objc
[self.mainSlideView addImage:[UIImage imageNamed:@"firstImage"] andText:@"Just like magic, add two lines of code and that's it..." toPageNumber:0];
[self.mainSlideView applyAnimationNumber:0 toGoFromPage:0];
[self.mainSlideView addImage:[UIImage imageNamed:@"secondImage"] andText:@"With multiple animations and some more options!" toPageNumber:1];
[self.mainSlideView applyAnimationNumber:0 toGoFromPage:1];
[self.mainSlideView addImage:[UIImage imageNamed:@"thirdImage"] andText:@"And some more customization is coming!" toPageNumber:2];
[self.mainSlideView applyAnimationNumber:0 toGoFromPage:2];
```

### More options

Add static images, text and customize your colors.

## Example

![RGDynamicOnboard](https://github.com/RamonGilabert/RGDynamicOnboard/blob/master/Resources/AppFirst.gif)

![RGDynamicOnboard](https://github.com/RamonGilabert/RGDynamicOnboard/blob/master/Resources/AppSecond.gif)

## Upcoming features

- Add more animations to the table.

## Contributing

1. Fork it.
2. Create your branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -am 'Added this feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create new pull request.

## Done by

[Ramon Gilabert](http://ramongilabert.com) with love! :)
