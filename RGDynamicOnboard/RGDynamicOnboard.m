#import "RGDynamicOnboard.h"

@interface RGDynamicOnboard () <UIScrollViewDelegate>

@property CGFloat deviceWidth;
@property CGFloat deviceHeight;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIWindow *mainView;
@property (strong, nonatomic) UIColor *colorSlide;
@property int numberOfPages;
@property NSMutableArray *arrayWithSlides;

@end

@implementation RGDynamicOnboard

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl inView:(UIView *)view
{
    self = [RGDynamicOnboard new];
    
    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

    self.arrayWithSlides = [NSMutableArray new];

    for (int i = 0; i < slides; i++) {
        [self.arrayWithSlides addObject:[NSNull null]];
    }

    self.mainView = [[[UIApplication sharedApplication] delegate] window];

    self.numberOfPages = slides;

    self.frame = CGRectMake(0, 0, self.deviceWidth, self.deviceHeight);
    self.pagingEnabled = YES;
    self.contentSize = CGSizeMake(self.deviceWidth * slides, self.deviceHeight);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.delegate = self;

    if (pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.deviceHeight - 100, self.deviceWidth, 20)];
        self.pageControl.numberOfPages = 4;
        [view addSubview: self];
        [view addSubview:self.pageControl];
    }

    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];

    return self;
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.numberOfPages) return;

    UIView *view = [self.arrayWithSlides objectAtIndex:page];

    if ((NSNull *)view == [NSNull null]) {
        view = [UIView new];
        [self.arrayWithSlides replaceObjectAtIndex:page withObject:view];
    }

    if (view.superview == nil)
    {
        if (page == 0) {
            view.backgroundColor = [UIColor redColor];
        } else if (page == 1) {
            view.backgroundColor = [UIColor blueColor];
        }

        CGRect frame = self.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        view.frame = frame;

        [self addSubview:view];
    }
}

#pragma mark - Delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.frame);
    NSUInteger page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

#pragma mark - Helper methods

- (void)getPageControlColorFromBackgroundColor:(UIColor *)backgroundColor
{
    CGFloat hue = 0;
    CGFloat saturation = 0;
    CGFloat brightness = 0;
    CGFloat alpha = 0;
    [backgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness-0.5 alpha:alpha];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness-0.3 alpha:alpha];
}

@end
