
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FontSize) {
    ARTSmallSizeFont = 8,
    ARTMediumSizeFont = 13,
    ARTLargeSizeFont = 30
};

@interface ARTProgressView : UIProgressView
{
    UILabel *lblLabel;
    UILabel *lblProgressLabelValue;
    CGRect lblProgressLabelValueInitFrame;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic) NSNumber *maxProgressLabelValue;
@property (nonatomic) FontSize labelFontSize;

-(void)reset;

@end
