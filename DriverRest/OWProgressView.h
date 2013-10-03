
#import <UIKit/UIKit.h>

@interface OWProgressView : UIView {
    UIProgressView *progressView;
    UILabel *lblProgressValue;
    NSString *label;
}

@property (nonatomic) NSNumber *progressValue;
@property (nonatomic) UIColor  *progressTintColor;
@property (nonatomic, copy) NSString *label;

-(void)resetToProgress:(NSNumber *)progress andHue:(NSNumber *)hue;

@end
