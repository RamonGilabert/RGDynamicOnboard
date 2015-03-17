#import "ViewController.h"
#import "RGDynamicOnboard.h"

@interface ViewController ()

@property UIView *viewHeader;
@property RGDynamicOnboard *mainSlideView;
@property CGFloat deviceWidth;
@property CGFloat deviceHeight;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNeedsStatusBarAppearanceUpdate];

    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

#pragma mark - Examples

    // IMPORTANT: It's important to add the line below this comment to use the examples!

    self.mainSlideView = [[RGDynamicOnboard alloc] initFullscreenWithNumberOfSlides:3 andPageControl:YES inView:self.view];

#pragma mark - First example

//    [self.mainSlideView addImage:[UIImage imageNamed:@"firstImage"] andText:@"Just like magic, add two lines of code and that's it..." toPageNumber:0];
//    [self.mainSlideView applyAnimationNumber:0 toGoFromPage:0];
//    [self.mainSlideView addImage:[UIImage imageNamed:@"secondImage"] andText:@"With multiple animations and some more options!" toPageNumber:1];
//    [self.mainSlideView applyAnimationNumber:0 toGoFromPage:1];
//    [self.mainSlideView addImage:[UIImage imageNamed:@"thirdImage"] andText:@"And some more customization is coming!" toPageNumber:2];
//    [self.mainSlideView applyAnimationNumber:0 toGoFromPage:2];

#pragma mark - Second example

//    [self.mainSlideView addStaticImage:[UIImage imageNamed:@"firstImage"] inPosition:3];
//    [self.mainSlideView addText:@"Just like magic too, add static images!" inPage:0];
//    [self.mainSlideView addText:@"Add then text to pages" inPage:1];

#pragma mark - Third example

//    [self.mainSlideView addBackgroundImage:[UIImage imageNamed:@"mountain"]];
//    [self.mainSlideView addText:@"Like magic, a background image all over the place" inPage:0 withColor:[UIColor whiteColor]];
//    [self.mainSlideView addText:@"Add then text to pages" inPage:1 withColor:[UIColor whiteColor]];

#pragma mark - Fourth example

    [self.mainSlideView addStaticImage:[UIImage imageNamed:@"firstImage"] inPosition:3];
}

#pragma mark - Change color status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
