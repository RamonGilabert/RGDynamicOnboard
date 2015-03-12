#import "RGDynamicOnboard.h"

@interface RGDynamicOnboard () <UIScrollViewDelegate>

@property CGFloat deviceWidth;
@property CGFloat deviceHeight;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIView *mainView;

@end

@implementation RGDynamicOnboard

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl
{
    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

    self.mainView = [[UIApplication sharedApplication].delegate window].subviews.firstObject;

    self = [RGDynamicOnboard new];
    self.frame = CGRectMake(0, 0, self.deviceWidth, self.deviceHeight);
    self.pagingEnabled = YES;
    self.contentSize = CGSizeMake(self.deviceWidth * slides, self.deviceHeight);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.delegate = self;

    self.backgroundColor = [UIColor blackColor];

    if (pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.deviceHeight - 25, self.deviceWidth, 20)];
        [self addSubview:self.pageControl];
    }

    [self.mainView addSubview:self];

    return self;
}

@end
