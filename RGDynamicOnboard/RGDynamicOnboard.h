#import <UIKit/UIKit.h>

@interface RGDynamicOnboard : UIScrollView

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl;
//- (instancetype)initWithPaddingTop:(float)padding numberOfSlides:(int)slides andPageControl:(BOOL)pageControl;

@end
