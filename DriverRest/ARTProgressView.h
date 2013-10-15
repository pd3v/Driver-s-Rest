
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FontSize) {
    ARTSmallSizeFont = 8,
    ARTMediumSizeFont = 15,
    ARTLargeSizeFont = 30
};

@interface ARTProgressView : UIProgressView
{
    UILabel *lblLabel;
    UILabel *lblValue;
    CGRect lblProgressLabelValueInitFrame;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *valueSuffix;
@property (nonatomic) NSNumber *maxValue;
@property (nonatomic) UIFont *font;

-(void)reset;

@end
