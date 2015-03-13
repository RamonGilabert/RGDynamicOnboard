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

    self.mainSlideView = [[RGDynamicOnboard alloc] initFullscreenWithNumberOfSlides:4 andPageControl:YES inView:self.view];
    [self.mainSlideView addImage:[UIImage imageNamed:@"firstImage"] andText:@"Just like magic, add two lines of code and that's it..." toPageNumber:0];
}

#pragma mark - Change color status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
