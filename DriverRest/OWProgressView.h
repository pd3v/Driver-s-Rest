
#import <UIKit/UIKit.h>

@interface OWProgressView : UIView {
    UIProgressView *progressView;
    UILabel *lblProgressValue;
    UILabel *lblDescription;
    CGRect lblProgressValueInitFrame;
}

@property (nonatomic) NSNumber *progressValue;
@property (nonatomic) NSNumber *maxLabelValue;
@property (nonatomic) NSNumber *progressTintColor;
@property (nonatomic, copy) NSString *description;

-(void)reset;

@end
