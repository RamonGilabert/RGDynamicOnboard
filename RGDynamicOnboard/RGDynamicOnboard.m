#import "RGDynamicOnboard.h"

@interface RGDynamicOnboard () <UIScrollViewDelegate>

@property CGFloat deviceWidth;
@property CGFloat deviceHeight;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIWindow *mainView;
@property (strong, nonatomic) UIColor *colorSlide;
@property int numberOfPages;
@property NSMutableArray *arrayWithSlides;
@property NSMutableArray *arrayOfAnimations;
@property CGFloat scrollOffset;

@end

@implementation RGDynamicOnboard

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl inView:(UIView *)view
{
    self = [RGDynamicOnboard new];
    
    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

    self.arrayWithSlides = [NSMutableArray new];
    self.arrayOfAnimations = [NSMutableArray new];

    for (int i = 0; i < slides; i++) {
        [self.arrayWithSlides addObject:[NSNull null]];
        [self.arrayOfAnimations addObject:[NSNull null]];
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
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.deviceHeight - 75, self.deviceWidth, 20)];
        self.pageControl.numberOfPages = slides;
        [self getPageControlColorFromBackgroundColor:[UIColor darkGrayColor]];
        [view addSubview: self];
        [view addSubview:self.pageControl];
    }

    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];

    return self;
}

- (void)addImage:(UIImage *)image andText:(NSString *)string toPageNumber:(int)page
{
    [self loadScrollViewWithPage:page];

    UIView *view = [self.arrayWithSlides objectAtIndex:page];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.deviceWidth - (self.deviceWidth/3))/2, self.deviceHeight/2 - self.deviceHeight/3 + 40, self.deviceWidth/3, self.deviceHeight/4)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];

    UILabel *labelWithText = [[UILabel alloc] initWithFrame:CGRectMake((self.deviceWidth - (self.deviceWidth - 150))/2, self.deviceHeight/2 + 100, self.deviceWidth - 80, 200)];
    labelWithText.textAlignment = NSTextAlignmentCenter;
    labelWithText.numberOfLines = 10;
    labelWithText.text = string;
    labelWithText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    [labelWithText sizeToFit];
    labelWithText.frame = CGRectMake((self.deviceWidth - labelWithText.frame.size.width)/2, self.deviceHeight/2 + 75, labelWithText.frame.size.width, labelWithText.frame.size.height);
    [view addSubview:labelWithText];

    [self.arrayWithSlides replaceObjectAtIndex:page withObject:view];
}

- (void)applyAnimationNumber:(int)animation toGoFromPage:(int)page
{
    [self.arrayOfAnimations replaceObjectAtIndex:page withObject:[NSNumber numberWithInt:animation]];
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
        CGRect frame = self.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        view.frame = frame;

        [self addSubview:view];
    }
}

#pragma mark - Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.frame);
    NSUInteger page = floor((self.contentOffset.x - pageWidth) / pageWidth) + 1;

    CGFloat realLocation = scrollView.contentOffset.x - self.deviceWidth * page;

    self.scrollOffset = realLocation;

    if ((int)page < 0) return;

    UIView *view = [self.arrayWithSlides objectAtIndex:page];
    UIView *viewSecond = [UIView new];

    if (page + 1 < self.arrayWithSlides.count) {
        viewSecond = [self.arrayWithSlides objectAtIndex:(page + 1)];
    }

    UIImageView *imageViewToAnimate = [UIImageView new];
    UILabel *labelToAnimate = [UILabel new];
    UIImageView *imageViewToAnimateFollowingPage = [UIImageView new];
    UILabel *labelToAnimateFollowingPage = [UILabel new];

    for (UIView *viewWeTake in view.subviews) {
        if ([viewWeTake isKindOfClass:[UILabel class]]) {
            labelToAnimate = (UILabel *)viewWeTake;
        } else if ([viewWeTake isKindOfClass:[UIImageView class]]) {
            imageViewToAnimate = (UIImageView *)viewWeTake;
        }
    }

    for (UIView *viewWeTake in viewSecond.subviews) {
        if ([viewWeTake isKindOfClass:[UILabel class]]) {
            labelToAnimateFollowingPage = (UILabel *)viewWeTake;
        } else if ([viewWeTake isKindOfClass:[UIImageView class]]) {
            imageViewToAnimateFollowingPage = (UIImageView *)viewWeTake;
        }
    }

    if (![self.arrayOfAnimations[page] isKindOfClass:[NSNull class]]) {
        if ([self.arrayOfAnimations[page] intValue] == 0) {
            imageViewToAnimate.frame = CGRectMake((self.deviceWidth - (self.deviceWidth/3))/2 + self.scrollOffset/1.5, self.deviceHeight/2 - self.deviceHeight/3 + 40 - realLocation, imageViewToAnimate.frame.size.width, imageViewToAnimate.frame.size.height);
            if (self.scrollOffset + 20 > self.frame.size.width) {
                imageViewToAnimateFollowingPage.frame = CGRectMake(imageViewToAnimateFollowingPage.frame.origin.x, self.deviceHeight/2 - self.deviceHeight/3 + 40, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
            } else {
                imageViewToAnimateFollowingPage.frame = CGRectMake(imageViewToAnimateFollowingPage.frame.origin.x, - self.frame.size.width + self.scrollOffset * 1.5, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.scrollOffset = 0;

    CGFloat pageWidth = CGRectGetWidth(self.frame);
    NSUInteger page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

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
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha-0.3];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha-0.5];
}

@end
