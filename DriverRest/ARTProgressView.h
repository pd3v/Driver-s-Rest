
#import <UIKit/UIKit.h>

@interface ARTProgressView : UIProgressView
{
    UILabel *lblLabel;
    UILabel *lblProgressLabelValue;
    CGRect lblProgressLabelValueInitFrame;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic) NSNumber *maxProgressLabelValue;

-(void)reset;

@end
