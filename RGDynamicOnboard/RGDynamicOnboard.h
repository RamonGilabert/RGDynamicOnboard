#import <UIKit/UIKit.h>

@interface RGDynamicOnboard : UIScrollView

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl inView:(UIView *)view;
//- (instancetype)initWithPaddingTop:(float)padding numberOfSlides:(int)slides andPageControl:(BOOL)pageControl;

@end
