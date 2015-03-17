#import <UIKit/UIKit.h>

@interface RGDynamicOnboard : UIScrollView

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl inView:(UIView *)view;
//- (instancetype)initWithPaddingTop:(float)padding numberOfSlides:(int)slides andPageControl:(BOOL)pageControl;

- (void)addImage:(UIImage *)image andText:(NSString *)string toPageNumber:(int)page;
- (void)applyAnimationNumber:(int)animation toGoFromPage:(int)page;

- (void)addStaticImage:(UIImage *)image inPosition:(int)position;
- (void)addStaticImage:(UIImage *)image inFrame:(CGRect)frame;
- (void)addStaticImage:(UIImage *)image inPosition:(int)position fromPage:(int)firstPage toPage:(int)secondPage withAnimationAppearance:(int)animationOption;

- (void)addText:(NSString *)string inPage:(int)page;
- (void)addText:(NSString *)string inPage:(int)page withColor:(UIColor *)color;

- (void)addBackgroundImage:(UIImage *)image;
- (void)addBackgroundImage:(UIImage *)image withFrame:(CGRect)frame;
- (void)addBackgroundImage:(UIImage *)image withX:(CGFloat)xValue withY:(CGFloat)yValue withAllWidthAndHeight:(CGFloat)height;

@end
