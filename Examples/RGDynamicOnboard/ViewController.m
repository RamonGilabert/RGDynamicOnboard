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

//    [self.mainSlideView addStaticImage:[UIImage imageNamed:@"firstImage"] inPosition:3 fromPage:0 toPage:1 withAnimationAppearance:1];
//    [self.mainSlideView addStaticImage:[UIImage imageNamed:@"secondImage"] inPosition:3 fromPage:1 toPage:3 withAnimationAppearance:0];

#pragma mark - Fifth example

//    [self.mainSlideView addEditableStaticImage:[UIImage imageNamed:@"thirdImage"] inPage:0 inFrame:CGRectMake((self.deviceWidth - 200)/2, 200, 200, 200) andGoToFrame:CGRectMake((self.deviceWidth - 100)/2, 0, 100, 100) toPage:1];
//    [self.mainSlideView image:[UIImage imageNamed:@"thirdImage"] toGoFromPage:1 toFrame:CGRectMake((self.deviceWidth - 200)/2, 200, 200, 200)];
//    self.mainSlideView.backgroundColorAllScrollView = [UIColor redColor];
//    self.mainSlideView.dismissButtonCornerColor = [UIColor whiteColor];
//    self.mainSlideView.dismissButtonFontColor = [UIColor whiteColor];

#pragma mark - Sixth example

//    [self.mainSlideView addImage:[UIImage imageNamed:@"firstImage"] inFrame:CGRectMake((self.deviceWidth - 200)/2, 200, 200, 200) inPage:1 withAnimation:0];

#pragma mark - Seventh example

//    [self.mainSlideView addImage:[UIImage imageNamed:@"firstImage"] andText:@"Just like magic, add two lines of code and that's it..." toPageNumber:0];
//    [self.mainSlideView applyAnimationNumber:1 toGoFromPage:0];
//    [self.mainSlideView addImage:[UIImage imageNamed:@"secondImage"] andText:@"With multiple animations and some more options!" toPageNumber:1];
//    [self.mainSlideView applyAnimationNumber:1 toGoFromPage:1];
//    [self.mainSlideView addImage:[UIImage imageNamed:@"thirdImage"] andText:@"And some more customization is coming!" toPageNumber:2];
//    [self.mainSlideView applyAnimationNumber:0 toGoFromPage:2];

#pragma mark - Eighth example

    [self.mainSlideView addBackgroundImage:[UIImage imageNamed:@"background"]];
    [self.mainSlideView addEditableStaticImage:[UIImage imageNamed:@"welcomeImage"] inPage:0 inFrame:CGRectMake(50, self.deviceHeight/3, self.deviceWidth - 100, 150) andGoToFrame:CGRectMake(100, 25, self.deviceWidth - 200, 100) toPage:1];
    [self.mainSlideView addImage:[UIImage imageNamed:@"fourthImage"] inFrame:CGRectMake((self.deviceWidth - 200)/2, (self.deviceHeight - 200)/2 - 50, 200, 200) inPage:1 withAnimation:1];
    [self.mainSlideView addString:@"Just like magic, just with 4 lines of code..." andFont:[UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:24] andTextColor:[UIColor whiteColor] inFrame:CGRectMake(50, self.deviceHeight - 280, self.deviceWidth - 100, 200) inPage:1 withAnimation:0];
    [self.mainSlideView image:[UIImage imageNamed:@"welcomeImage"] toGoFromPage:1 toFrame:CGRectMake(50, self.deviceHeight/3, self.deviceWidth - 100, 150)];
    


}

#pragma mark - Change color status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
