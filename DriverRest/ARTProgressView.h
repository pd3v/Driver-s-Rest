
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FontSize) {
    ARTSmallSizeFont = 8,
    ARTMediumSizeFont = 15,
    ARTLargeSizeFont = 30
};

typedef NS_ENUM(NSUInteger, ProgressionType) {
    ARTAscending,
    ARTDescending
};


@interface ARTProgressView : UIProgressView
{
    UILabel *lblLabel;
    UILabel *lblProgressLabelValue;
    CGRect lblProgressLabelValueInitFrame;
    ProgressionType progressionType;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic) NSNumber *maxProgressLabelValue;
@property (nonatomic) FontSize labelFontSize;
// @property (nonatomic) ProgressionType progressionType;

-(void)reset;

@end
