#import "RGDynamicOnboard.h"

@interface RGDynamicOnboard () <UIScrollViewDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIWindow *mainView;
@property (strong, nonatomic) UIColor *colorSlide;
@property (strong, nonatomic) UIView *viewMain;
@property (strong, nonatomic) UIButton *buttonDismiss;
@property (strong, nonatomic) UIImageView *staticImageView;
@property (strong, nonatomic) UIImageView *staticImageViewSecond;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *imageViewThatMoves;
@property (strong, nonatomic) NSMutableArray *arrayWithSlides;
@property (strong, nonatomic) NSMutableArray *arrayOfAnimations;
@property (strong, nonatomic) NSMutableArray *arrayWithImagesAnimation;
@property (strong, nonatomic) NSMutableArray *arrayWithImages;
@property (strong, nonatomic) NSMutableArray *arrayWithImagesPages;
@property (strong, nonatomic) NSMutableArray *arrayOfFrames;
@property (strong, nonatomic) NSMutableArray *arrayOfFramesX;
@property (weak, nonatomic) NSNumber *firstPageFirst;
@property (weak, nonatomic) NSNumber *firstPageSecond;
@property (weak, nonatomic) NSNumber *secondPageFirst;
@property (weak, nonatomic) NSNumber *secondPageSecond;
@property CGRect frameToGo;
@property CGRect initialFrame;
@property CGRect initialFrameOnceAnimationDone;
@property CGRect finalFrameOnceAnimationDone;
@property CGFloat deviceWidth;
@property CGFloat deviceHeight;
@property CGFloat scrollOffset;
@property int numberOfPages;
@property int animationStaticImage;
@property int animationStaticImageSecond;
@property int pageToPerformFirstAnimation;
@property int pageToPerformSecondAnimation;
@property int pageToPerformThirdAnimation;

@end

@implementation RGDynamicOnboard

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl inView:(UIView *)view
{
    self = [RGDynamicOnboard new];

    self.pageToPerformFirstAnimation = 100;
    self.pageToPerformSecondAnimation = 100;
    self.pageToPerformThirdAnimation = 100;

    self.viewMain = [UIView new];
    self.viewMain = view;
    
    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

    self.arrayWithSlides = [NSMutableArray new];
    self.arrayOfAnimations = [NSMutableArray new];
    self.arrayWithImages = [NSMutableArray new];
    self.arrayWithImagesAnimation = [NSMutableArray new];
    self.arrayWithImagesPages = [NSMutableArray new];
    self.arrayOfFrames = [NSMutableArray new];
    self.arrayOfFramesX = [NSMutableArray new];

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
        [self.viewMain addSubview:self.pageControl];
    }

    [self.viewMain addSubview: self];

    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
    [self loadScrollViewWithPage:3];

    return self;
}

- (void)addBackgroundColor:(UIColor *)color inPage:(int)page
{
    if (page >= self.numberOfPages) return;

    UIView *view = [self.arrayWithSlides objectAtIndex:page];

    if ((NSNull *)view == [NSNull null]) {
        view = [UIView new];
        [self.arrayWithSlides replaceObjectAtIndex:page withObject:view];
    }

    view.backgroundColor = color;
}

- (void)setBackgroundColorAllScrollView:(UIColor *)backgroundColorAllScrollView
{
    self.viewMain.backgroundColor = backgroundColorAllScrollView;

    if (self.pageControl) {
        CGFloat hueColor;
        CGFloat saturationColor;
        CGFloat brightnessColor;
        CGFloat alphaColor;

        [backgroundColorAllScrollView getHue:&hueColor saturation:&saturationColor brightness:&brightnessColor alpha:&alphaColor];

        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHue:hueColor saturation:saturationColor brightness:brightnessColor-0.4 alpha:alphaColor];
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithHue:hueColor saturation:saturationColor brightness:brightnessColor-0.2 alpha:alphaColor];
    }
}

- (void)setDismissButtonCornerColor:(UIColor *)dismissButtonCornerColor
{
    self.buttonDismiss.layer.borderColor = dismissButtonCornerColor.CGColor;
}

- (void)setDismissButtonFontColor:(UIColor *)dismissButtonFontColor
{
    [self.buttonDismiss setTitleColor:dismissButtonFontColor forState:UIControlStateNormal];
}

- (void)setDismissButtonBackgroundColor:(UIColor *)dismissButtonBackgroundColor
{
    self.buttonDismiss.backgroundColor = dismissButtonBackgroundColor;
}

- (void)addImage:(UIImage *)image inFrame:(CGRect)frame inPage:(int)page withAnimation:(int)animation
{
    if (page >= self.numberOfPages) return;

    UIView *view = [self.arrayWithSlides objectAtIndex:page];

    if ((NSNull *)view == [NSNull null]) {
        view = [UIView new];
        [self.arrayWithSlides replaceObjectAtIndex:page withObject:view];
    }

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image;

    [self.arrayWithImagesPages addObject:[NSNumber numberWithInt:page]];
    [self.arrayWithImagesAnimation addObject:[NSNumber numberWithInt:animation]];
    [self.arrayWithImages addObject:imageView];
    [self.arrayOfFrames addObject:[NSNumber numberWithFloat:imageView.frame.origin.y]];
    [self.arrayOfFramesX addObject:[NSNumber numberWithFloat:imageView.frame.origin.x]];

    [view addSubview:imageView];
}

- (void)addString:(NSString *)text inFrame:(CGRect)frame inPage:(int)page withAnimation:(int)animation
{
    if (page >= self.numberOfPages) return;

    UIView *view = [self.arrayWithSlides objectAtIndex:page];

    if ((NSNull *)view == [NSNull null]) {
        view = [UIView new];
        [self.arrayWithSlides replaceObjectAtIndex:page withObject:view];
    }

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.numberOfLines = 10;
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:22];

    [view addSubview:label];
}

- (void)addString:(NSString *)text andFont:(UIFont *)font inFrame:(CGRect)frame inPage:(int)page withAnimation:(int)animation
{
    if (page >= self.numberOfPages) return;

    UIView *view = [self.arrayWithSlides objectAtIndex:page];

    if ((NSNull *)view == [NSNull null]) {
        view = [UIView new];
        [self.arrayWithSlides replaceObjectAtIndex:page withObject:view];
    }

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.numberOfLines = 10;
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;

    [view addSubview:label];
}

- (void)addString:(NSString *)text andFont:(UIFont *)font andTextColor:(UIColor *)color inFrame:(CGRect)frame inPage:(int)page withAnimation:(int)animation
{
    if (page >= self.numberOfPages) return;

    UIView *view = [self.arrayWithSlides objectAtIndex:page];

    if ((NSNull *)view == [NSNull null]) {
        view = [UIView new];
        [self.arrayWithSlides replaceObjectAtIndex:page withObject:view];
    }

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.numberOfLines = 10;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;

    [view addSubview:label];
}

- (void)addEditableStaticImage:(UIImage *)image inPage:(int)page inFrame:(CGRect)initialFrame andGoToFrame:(CGRect)secondFrame toPage:(int)pageToGo
{
    if (image) {
        self.imageViewThatMoves = [[UIImageView alloc] initWithFrame:initialFrame];
        self.imageViewThatMoves.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewThatMoves.image = image;
        self.frameToGo = secondFrame;
        self.pageToPerformFirstAnimation = page;
        self.pageToPerformSecondAnimation = pageToGo - 1;
        self.initialFrame = initialFrame;

        if (page == 0) {
            [self.viewMain addSubview:self.imageViewThatMoves];
        }
    }
}

- (void)image:(UIImage *)image toGoFromPage:(int)page toFrame:(CGRect)lastFrame
{
    if ([self.imageViewThatMoves.image isEqual:image]) {
        self.pageToPerformThirdAnimation = page;
        self.finalFrameOnceAnimationDone = lastFrame;
    }
}

- (void)addBackgroundImage:(UIImage *)image
{
    if (image) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*self.numberOfPages, self.deviceHeight)];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.image = image;
        [self insertSubview:self.backgroundImageView atIndex:0];

        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self.viewMain bringSubviewToFront:self.pageControl];

        self.buttonDismiss.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.buttonDismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)addBackgroundImage:(UIImage *)image withFrame:(CGRect)frame
{
    if (image) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.image = image;
        [self insertSubview:self.backgroundImageView atIndex:0];

        if (frame.origin.y > self.deviceHeight/2 || frame.size.height >= self.deviceHeight) {
            self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            self.buttonDismiss.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.buttonDismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)addBackgroundImage:(UIImage *)image withX:(CGFloat)xValue withY:(CGFloat)yValue withAllWidthAndHeight:(CGFloat)height
{
    if (image) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, yValue, self.frame.size.width*self.numberOfPages, height)];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.image = image;
        [self insertSubview:self.backgroundImageView atIndex:0];

        if (yValue > self.deviceHeight/2 || height >= self.deviceHeight) {
            self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            
            self.buttonDismiss.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.buttonDismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)addStaticImage:(UIImage *)image inPosition:(int)position
{
    self.staticImageView = [UIImageView new];

    if (position == 0) {
        self.staticImageView.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2, (self.deviceHeight - self.deviceHeight/3)/2 - 25, self.deviceWidth/1.7, self.deviceHeight/3);
    } else if (position == 1) {
        self.staticImageView.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2 + 60, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
    } else if (position == 2) {
        self.staticImageView.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2 - 60, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
    } else {
        self.staticImageView.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
    }

    self.staticImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.staticImageView.image = image;

    [self.viewMain addSubview:self.staticImageView];
}

- (void)addStaticImage:(UIImage *)image inPosition:(int)position fromPage:(int)firstPage toPage:(int)secondPage withAnimationAppearance:(int)animationOption
{
    if (!self.firstPageFirst) {
        self.animationStaticImage = animationOption;

        self.firstPageFirst = [NSNumber numberWithInt:firstPage];
        self.firstPageSecond = [NSNumber numberWithInt:secondPage];

        self.staticImageView = [UIImageView new];

        if (position == 0) {
            self.staticImageView.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2, (self.deviceHeight - self.deviceHeight/3)/2 - 25, self.deviceWidth/1.7, self.deviceHeight/3);
        } else if (position == 1) {
            self.staticImageView.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2 + 60, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
        } else if (position == 2) {
            self.staticImageView.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2 - 60, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
        } else {
            self.staticImageView.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
        }

        self.staticImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.staticImageView.image = image;

    } else {
        self.animationStaticImageSecond = animationOption;

        self.secondPageFirst = [NSNumber numberWithInt:firstPage];
        self.secondPageSecond = [NSNumber numberWithInt:secondPage];

        self.staticImageViewSecond = [UIImageView new];

        if (position == 0) {
            self.staticImageViewSecond.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2, (self.deviceHeight - self.deviceHeight/3)/2 - 25, self.deviceWidth/1.7, self.deviceHeight/3);
        } else if (position == 1) {
            self.staticImageViewSecond.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2 + 60, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
        } else if (position == 2) {
            self.staticImageViewSecond.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2 - 60, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
        } else {
            self.staticImageViewSecond.frame = CGRectMake((self.deviceWidth - self.deviceWidth/1.7)/2, (self.deviceHeight - self.deviceHeight/3)/2 - 100, self.deviceWidth/1.7, self.deviceHeight/3);
        }

        self.staticImageViewSecond.contentMode = UIViewContentModeScaleAspectFill;
        self.staticImageViewSecond.image = image;
    }

    [self.viewMain addSubview:self.staticImageView];
}

- (void)addStaticImage:(UIImage *)image inFrame:(CGRect)frame
{
    if (&frame && image) {
        self.staticImageView = [[UIImageView alloc] initWithFrame:frame];
        self.staticImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.staticImageView.image = image;
        [self.viewMain addSubview:self.staticImageView];
    }
}

- (void)addText:(NSString *)string inPage:(int)page withColor:(UIColor *)color
{
    UIView *view = [self.arrayWithSlides objectAtIndex:page];
    UILabel *labelOfText = [[UILabel alloc] initWithFrame:CGRectMake(25, self.deviceHeight - self.deviceHeight/6, self.deviceWidth - 50, 200)];
    labelOfText.numberOfLines = 10;
    labelOfText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    labelOfText.textColor = color;
    labelOfText.textAlignment = NSTextAlignmentCenter;
    labelOfText.text = string;
    [labelOfText sizeToFit];
    CGRect rectOfLabel = labelOfText.frame;
    labelOfText.frame = CGRectMake((self.deviceWidth - rectOfLabel.size.width)/2, self.deviceHeight - rectOfLabel.size.height - self.deviceHeight/4, rectOfLabel.size.width, rectOfLabel.size.height);
    [view addSubview:labelOfText];
}

- (void)addText:(NSString *)string inPage:(int)page
{
    UIView *view = [self.arrayWithSlides objectAtIndex:page];
    UILabel *labelOfText = [[UILabel alloc] initWithFrame:CGRectMake(25, self.deviceHeight - self.deviceHeight/6, self.deviceWidth - 50, 200)];
    labelOfText.numberOfLines = 10;
    labelOfText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    labelOfText.textAlignment = NSTextAlignmentCenter;
    labelOfText.text = string;
    [labelOfText sizeToFit];
    CGRect rectOfLabel = labelOfText.frame;
    labelOfText.frame = CGRectMake((self.deviceWidth - rectOfLabel.size.width)/2, self.deviceHeight - rectOfLabel.size.height - self.deviceHeight/4, rectOfLabel.size.width, rectOfLabel.size.height);
    [view addSubview:labelOfText];
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

- (void)onDismissButtonPressed
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.staticImageView) {
            self.staticImageView.transform = CGAffineTransformMakeScale(3, 3);
            self.staticImageView.alpha = 0;
        }

        if (self.staticImageViewSecond) {
            self.staticImageViewSecond.transform = CGAffineTransformMakeScale(3, 3);
            self.staticImageViewSecond.alpha = 0;
        }

        if (self.imageViewThatMoves) {
            self.imageViewThatMoves.transform = CGAffineTransformMakeScale(3, 3);
            self.imageViewThatMoves.alpha = 0;
        }

        self.transform = CGAffineTransformMakeScale(3, 3);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.staticImageView) {
            [self.staticImageView removeFromSuperview];
        }

        if (self.staticImageViewSecond) {
            [self.staticImageViewSecond removeFromSuperview];
        }

        if (self.imageViewThatMoves) {
            [self.imageViewThatMoves removeFromSuperview];
        }

        [self removeFromSuperview];
    }];
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

    if ((int)(page + 1) == (int)self.arrayWithSlides.count) {
        if (!self.buttonDismiss) {
            self.buttonDismiss = [[UIButton alloc] initWithFrame:CGRectMake(50, self.deviceHeight - self.deviceHeight/5.5, self.deviceWidth - 100, 65)];
            self.buttonDismiss.layer.cornerRadius = 7.5;
            self.buttonDismiss.layer.borderColor = [UIColor darkGrayColor].CGColor;
            self.buttonDismiss.layer.borderWidth = 2;
            self.buttonDismiss.titleLabel.font = [UIFont fontWithName:@"Avenir" size:26];
            [self.buttonDismiss setTitle:@"Start this journey" forState:UIControlStateNormal];
            [self.buttonDismiss setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [self.buttonDismiss addTarget:self action:@selector(onDismissButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            self.buttonDismiss.alpha = 0;
            [view addSubview:self.buttonDismiss];
        }
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

    if (view.subviews.count > 0) {
        for (UIView *viewWeTake in view.subviews) {
            if ([viewWeTake isKindOfClass:[UILabel class]]) {
                labelToAnimate = (UILabel *)viewWeTake;
            } else if ([viewWeTake isKindOfClass:[UIImageView class]]) {
                imageViewToAnimate = (UIImageView *)viewWeTake;
            }
        }
    }

    if (![viewSecond isKindOfClass:[NSNull class]]) {
        for (UIView *viewWeTake in viewSecond.subviews) {
            if ([viewWeTake isKindOfClass:[UILabel class]]) {
                labelToAnimateFollowingPage = (UILabel *)viewWeTake;
            } else if ([viewWeTake isKindOfClass:[UIImageView class]]) {
                imageViewToAnimateFollowingPage = (UIImageView *)viewWeTake;
            }
        }
    }

    for (NSNumber *number in self.arrayWithImagesPages) {
        if ([number intValue] == page) {
            int indexOfPage = (int)[self.arrayWithImagesPages indexOfObject:number];
            UIImageView *imageView = self.arrayWithImages[indexOfPage];

            if ([self.arrayWithImagesAnimation[indexOfPage] isEqual:[NSNumber numberWithInt:0]]) {
                imageView.frame = CGRectMake([self.arrayOfFramesX[indexOfPage] floatValue] + self.scrollOffset/1.5, [self.arrayOfFrames[indexOfPage] floatValue] - self.scrollOffset*1.5, imageView.frame.size.width, imageView.frame.size.height);
            }
        } else if ([number intValue] == page + 1) {
            int indexOfPage = (int)[self.arrayWithImagesPages indexOfObject:number];
            UIImageView *imageView = self.arrayWithImages[indexOfPage];

            if ([self.arrayWithImagesAnimation[indexOfPage] isEqual:[NSNumber numberWithInt:0]]) {
                imageView.frame = CGRectMake([self.arrayOfFramesX[indexOfPage] floatValue] - (self.frame.size.width - self.scrollOffset)/1.5, [self.arrayOfFrames[indexOfPage] floatValue] - (self.frame.size.width - self.scrollOffset)*1.5, imageView.frame.size.width, imageView.frame.size.height);
            }
        }
    }

    if (self.pageToPerformSecondAnimation == (int)page) {
        CGFloat floatValue = (self.frameToGo.origin.y - self.initialFrame.origin.y)/self.frame.size.width;
        CGFloat floatValueX = (self.frameToGo.origin.x - self.initialFrame.origin.x)/self.frame.size.width;
        CGFloat floatValueHeight = (self.frameToGo.size.height - self.initialFrame.size.height)/self.frame.size.width;
        CGFloat floatValueWidth = (self.frameToGo.size.width - self.initialFrame.size.width)/self.frame.size.width;

        self.imageViewThatMoves.frame = CGRectMake(self.initialFrame.origin.x + self.scrollOffset*floatValueX, self.initialFrame.origin.y + self.scrollOffset*floatValue, self.initialFrame.size.width + self.scrollOffset*floatValueWidth, self.initialFrame.size.height + self.scrollOffset*floatValueHeight);
    }

    if (self.pageToPerformThirdAnimation == (int)page) {
        CGFloat floatValue = (self.frameToGo.origin.y - self.finalFrameOnceAnimationDone.origin.y)/self.frame.size.width;
        CGFloat floatValueX = (self.frameToGo.origin.x - self.finalFrameOnceAnimationDone.origin.x)/self.frame.size.width;
        CGFloat floatValueHeight = (self.frameToGo.size.height - self.finalFrameOnceAnimationDone.size.height)/self.frame.size.width;
        CGFloat floatValueWidth = (self.frameToGo.size.width - self.finalFrameOnceAnimationDone.size.width)/self.frame.size.width;

        self.imageViewThatMoves.frame = CGRectMake(self.frameToGo.origin.x - self.scrollOffset*floatValueX, self.frameToGo.origin.y - self.scrollOffset*floatValue, self.frameToGo.size.width - self.scrollOffset*floatValueWidth, self.frameToGo.size.height - self.scrollOffset*floatValueHeight);
    }

    if (![self.arrayOfAnimations[page] isKindOfClass:[NSNull class]]) {
        if ([self.arrayOfAnimations[page] intValue] == 0) {
            imageViewToAnimate.frame = CGRectMake((self.deviceWidth - (self.deviceWidth/3))/2 + self.scrollOffset/1.5, self.deviceHeight/2 - self.deviceHeight/3 + 40 - realLocation, imageViewToAnimate.frame.size.width, imageViewToAnimate.frame.size.height);

            if (imageViewToAnimateFollowingPage && (self.arrayOfAnimations.count >= page + 2)) {
                if (![self.arrayOfAnimations[page + 1] isKindOfClass:[NSNull class]]) {
                    if ([self.arrayOfAnimations[page + 1] intValue] == 0) {
                        if (self.scrollOffset + 20 > self.frame.size.width) {
                            imageViewToAnimateFollowingPage.frame = CGRectMake(imageViewToAnimateFollowingPage.frame.origin.x, self.deviceHeight/2 - self.deviceHeight/3 + 40, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
                        } else {
                            imageViewToAnimateFollowingPage.frame = CGRectMake(imageViewToAnimateFollowingPage.frame.origin.x, - self.frame.size.width + self.scrollOffset * 1.5, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
                        }
                    } else if ([self.arrayOfAnimations[page + 1] intValue] == 1) {
                        if (self.scrollOffset > self.frame.size.width) {
                            imageViewToAnimateFollowingPage.transform = CGAffineTransformMakeScale(1 - (realLocation/self.frame.size.width), 1 - (realLocation/self.frame.size.width));
                            imageViewToAnimateFollowingPage.frame = CGRectMake((self.deviceWidth - (self.deviceWidth/3))/2 + realLocation/1.5, imageViewToAnimateFollowingPage.frame.origin.y, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
                        } else {
                            imageViewToAnimateFollowingPage.transform = CGAffineTransformMakeScale(realLocation/self.frame.size.width, realLocation/self.frame.size.width);
                            imageViewToAnimateFollowingPage.frame = CGRectMake((self.deviceWidth - (self.deviceWidth/3))/2 - realLocation/1.5, imageViewToAnimateFollowingPage.frame.origin.y, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
                        }
                    }
                }
            }
        } else if ([self.arrayOfAnimations[page] intValue] == 1) {
            if (self.scrollOffset > self.frame.size.width) {
                imageViewToAnimate.transform = CGAffineTransformMakeScale(realLocation/self.frame.size.width, realLocation/self.frame.size.width);
                imageViewToAnimate.frame = CGRectMake((self.deviceWidth - (self.deviceWidth/3))/2 + realLocation/1.5, imageViewToAnimate.frame.origin.y, imageViewToAnimate.frame.size.width, imageViewToAnimate.frame.size.height);

                imageViewToAnimateFollowingPage.transform = CGAffineTransformMakeScale(1 - (realLocation/self.frame.size.width), 1 - (realLocation/self.frame.size.width));
                imageViewToAnimateFollowingPage.frame = CGRectMake((self.deviceWidth - (self.deviceWidth/3))/2 + realLocation/1.5, imageViewToAnimateFollowingPage.frame.origin.y, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
            } else {
                imageViewToAnimate.transform = CGAffineTransformMakeScale(1 - (realLocation/self.frame.size.width), 1 - (realLocation/self.frame.size.width));
            }

            if (imageViewToAnimateFollowingPage && (self.arrayOfAnimations.count >= page + 2)) {
                if ([self.arrayOfAnimations[page + 1] intValue] == 0) {
                    if (self.scrollOffset + 20 > self.frame.size.width) {
                        imageViewToAnimateFollowingPage.frame = CGRectMake(imageViewToAnimateFollowingPage.frame.origin.x, self.deviceHeight/2 - self.deviceHeight/3 + 40, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
                    } else {
                        imageViewToAnimateFollowingPage.frame = CGRectMake(imageViewToAnimateFollowingPage.frame.origin.x, - self.frame.size.width + self.scrollOffset * 1.5, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
                    }
                } else if ([self.arrayOfAnimations[page + 1] intValue] == 1) {
                    if (self.scrollOffset > self.frame.size.width) {
                        imageViewToAnimateFollowingPage.transform = CGAffineTransformMakeScale(1 - (realLocation/self.frame.size.width), 1 - (realLocation/self.frame.size.width));
                        imageViewToAnimateFollowingPage.frame = CGRectMake((self.deviceWidth - (self.deviceWidth/3))/2 + realLocation/1.5, imageViewToAnimateFollowingPage.frame.origin.y, imageViewToAnimateFollowingPage.frame.size.width, imageViewToAnimateFollowingPage.frame.size.height);
                    } else {
                        imageViewToAnimateFollowingPage.transform = CGAffineTransformMakeScale(realLocation/self.frame.size.width, realLocation/self.frame.size.width);
                    }
                }
            }
        }
    }

    if ((int)(page + 2) == (int)self.arrayWithSlides.count) {
        self.pageControl.alpha = (self.frame.size.width - self.scrollOffset)/self.frame.size.width;
        self.buttonDismiss.alpha = self.scrollOffset/self.frame.size.width;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.scrollOffset = 0;

    CGFloat pageWidth = CGRectGetWidth(self.frame);
    NSUInteger page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

    if (self.pageToPerformFirstAnimation == (int)page && ![self.viewMain.subviews containsObject:self.imageViewThatMoves]) {
        [self.viewMain addSubview:self.imageViewThatMoves];
        self.imageViewThatMoves.alpha = 0;

        self.imageViewThatMoves.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.3 animations:^{
            self.imageViewThatMoves.alpha = 1;
            self.imageViewThatMoves.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.imageViewThatMoves.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }

    if ((int)page < self.pageToPerformFirstAnimation) {
        self.imageViewThatMoves.transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.2 animations:^{
            self.imageViewThatMoves.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.4 animations:^{
                self.imageViewThatMoves.transform = CGAffineTransformMakeScale(0, 0);
                self.imageViewThatMoves.alpha = 0;
            } completion:^(BOOL finished) {
                [self.imageViewThatMoves removeFromSuperview];
            }];
        }];
    }

    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    [self loadScrollViewWithPage:page + 2];
    [self loadScrollViewWithPage:page + 3];

    if ([self.firstPageSecond intValue] == (int)page) {
        [self.staticImageView removeFromSuperview];
    } else if ([self.firstPageFirst intValue] == (int)page) {
        [self.mainView addSubview:self.staticImageView];
        self.staticImageView.alpha = 0;

        if (self.animationStaticImage == 0) {
            self.staticImageView.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:0.3 animations:^{
                self.staticImageView.alpha = 1;
                self.staticImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.staticImageView.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
        } else if (self.animationStaticImage == 1) {
            self.staticImageView.transform = CGAffineTransformMakeTranslation(10, -500);
            [UIView animateWithDuration:0.3 animations:^{
                self.staticImageView.alpha = 1;
                self.staticImageView.transform = CGAffineTransformMakeTranslation(0, 20);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.staticImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                }];
            }];
        } else {
            self.staticImageView.alpha = 1;
        }

        if ([self.mainView.subviews containsObject:self.staticImageViewSecond]) {
            [self.staticImageViewSecond removeFromSuperview];
        }
    }

    if ([self.secondPageFirst intValue] == (int)page && ![self.mainView.subviews containsObject:self.staticImageViewSecond]) {
        [self.mainView addSubview:self.staticImageViewSecond];
        self.staticImageViewSecond.alpha = 0;

        if (self.animationStaticImageSecond == 0) {
            self.staticImageViewSecond.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:0.3 animations:^{
                self.staticImageViewSecond.alpha = 1;
                self.staticImageViewSecond.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.staticImageViewSecond.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
        } else if (self.animationStaticImageSecond == 1) {
            self.staticImageViewSecond.transform = CGAffineTransformMakeTranslation(10, -500);
            [UIView animateWithDuration:0.3 animations:^{
                self.staticImageViewSecond.alpha = 1;
                self.staticImageViewSecond.transform = CGAffineTransformMakeTranslation(0, 20);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.staticImageViewSecond.transform = CGAffineTransformMakeTranslation(0, 0);
                }];
            }];
        } else {
            self.staticImageViewSecond.alpha = 1;
        }
    } else if ([self.secondPageSecond intValue] == (int)page) {
        [self.staticImageViewSecond removeFromSuperview];
    }
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
