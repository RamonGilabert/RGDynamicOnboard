#import <UIKit/UIKit.h>

@interface RGDynamicOnboard : UIScrollView

@property (strong, nonatomic) UIColor *backgroundColorAllScrollView;
@property (strong, nonatomic) UIColor *dismissButtonCornerColor;
@property (strong, nonatomic) UIColor *dismissButtonFontColor;
@property (strong, nonatomic) UIColor *dismissButtonBackgroundColor;

- (instancetype)initFullscreenWithNumberOfSlides:(int)slides andPageControl:(BOOL)pageControl inView:(UIView *)view;

- (void)addImage:(UIImage *)image andText:(NSString *)string toPageNumber:(int)page;
- (void)applyAnimationNumber:(int)animation toGoFromPage:(int)page;

- (void)addStaticImage:(UIImage *)image inPosition:(int)position;
- (void)addStaticImage:(UIImage *)image inFrame:(CGRect)frame;
- (void)addStaticImage:(UIImage *)image inPosition:(int)position fromPage:(int)firstPage toPage:(int)secondPage withAnimationAppearance:(int)animationOption;

- (void)addText:(NSString *)string inPage:(int)page withFontColor:(UIColor *)color;
- (void)addText:(NSString *)string inPage:(int)page withColor:(UIColor *)color;

- (void)addBackgroundImage:(UIImage *)image;
- (void)addBackgroundImage:(UIImage *)image withFrame:(CGRect)frame;
- (void)addBackgroundImage:(UIImage *)image withX:(CGFloat)xValue withY:(CGFloat)yValue withAllWidthAndHeight:(CGFloat)height;

- (void)addEditableStaticImage:(UIImage *)image inPage:(int)page inFrame:(CGRect)initialFrame andGoToFrame:(CGRect)secondFrame toPage:(int)pageToGo;
- (void)image:(UIImage *)image toGoFromPage:(int)page toFrame:(CGRect)lastFrame;

- (void)addImage:(UIImage *)image inFrame:(CGRect)frame inPage:(int)page withAnimation:(int)animation;
- (void)addString:(NSString *)text inFrame:(CGRect)frame inPage:(int)page withAnimation:(int)animation;
- (void)addString:(NSString *)text andFont:(UIFont *)font inFrame:(CGRect)frame inPage:(int)page withAnimation:(int)animation;
- (void)addString:(NSString *)text andFont:(UIFont *)font andTextColor:(UIColor *)color inFrame:(CGRect)frame inPage:(int)page withAnimation:(int)animation;

- (void)addBackgroundColor:(UIColor *)color inPage:(int)page;

@end
