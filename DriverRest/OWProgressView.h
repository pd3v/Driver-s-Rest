
#import <UIKit/UIKit.h>

@interface OWProgressView : UIView {
    UIProgressView *progress;
    UILabel *lblGasLevel;
}

@property (nonatomic) NSNumber *numProgress;
@property (nonatomic) UIProgressView *progress;

-(void)recomecarViagem;

@end
