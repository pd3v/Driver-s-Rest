
#import <UIKit/UIKit.h>

@interface ARTProgressView : UIProgressView
{
    UILabel *lblLabel;
    UILabel *lblProgressValue;
    CGRect lblProgressValueInitFrame;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic) NSNumber *maxLabelValue;

-(void)reset;

@end
