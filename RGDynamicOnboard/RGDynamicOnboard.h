#import <UIKit/UIKit.h>

@interface RGDynamicOnboard : UIScrollView

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl inView:(UIView *)view;
//- (instancetype)initWithPaddingTop:(float)padding numberOfSlides:(int)slides andPageControl:(BOOL)pageControl;

- (void)addImage:(UIImage *)image andText:(NSString *)string toPageNumber:(int)page;
- (void)applyAnimationNumber:(int)animation toGoFromPage:(int)page;
- (void)addStaticImage:(UIImage *)image inPosition:(int)position;
- (void)addStaticImage:(UIImage *)image inFrame:(CGRect)frame;

@end
