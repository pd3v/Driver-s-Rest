
#import <UIKit/UIKit.h>

@interface OWProgressView : UIView {
    UIProgressView *progressView;
    UILabel *lblProgressValue;
    UILabel *lblDescription;
    //CGFloat maxValue;
}

@property (nonatomic) NSNumber *progressValue;
@property (nonatomic) NSNumber *maxValue;
//@property (nonatomic) UILabel *maxValue;
//@property (nonatomic) UIColor  *progressTintColor;
@property (nonatomic) NSNumber *progressTintColor;
//@property (nonatomic) UILabel *lblDescription;
@property (nonatomic, copy) NSString *description;

-(void)reset:(NSNumber *)progress max:(NSNumber *)max hue:(NSNumber *)hue;

@end
