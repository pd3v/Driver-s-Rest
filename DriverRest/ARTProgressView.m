
#import "ARTProgressView.h"

@implementation ARTProgressView

@synthesize maxProgressLabelValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.progress = 1.0;
        
        lblLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-18, frame.size.width, 15)];
        lblLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        lblLabel.backgroundColor = [UIColor clearColor];

        lblProgressLabelValueInitFrame = CGRectMake(self.frame.size.width - 35, self.frame.size.height+2, 35, 15);
        lblProgressLabelValue = [[UILabel alloc]initWithFrame:lblProgressLabelValueInitFrame];
        lblProgressLabelValue.textAlignment = NSTextAlignmentLeft;
        [lblProgressLabelValue sizeToFit];
        lblProgressLabelValue.backgroundColor = [UIColor clearColor];
        lblProgressLabelValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        
        [self addSubview:(UIView *) lblLabel];
        [self addSubview:(UIView *) lblProgressLabelValue];
    }
    return self;
}

- (void)setProgress:(CGFloat)value {
    
    [super progress];
    
    CGRect lblProgressLabelValueFrame = lblProgressLabelValue.frame;
    
    if (lblProgressLabelValue.frame.origin.x >= value * self.frame.size.width)
        lblProgressLabelValueFrame = CGRectMake(value * self.frame.size.width, lblProgressLabelValue.frame.origin.y, lblProgressLabelValue.frame.size.width , lblProgressLabelValue.frame.size.height);
    
    lblProgressLabelValue.frame = lblProgressLabelValueFrame;
    lblProgressLabelValue.text = [NSString stringWithFormat:@"%.1f l", self.progress  * [maxProgressLabelValue floatValue]];
    [lblProgressLabelValue sizeToFit];
    
    [self setProgress:value animated:TRUE];
}

- (void)setLabel:(NSString *)aText {
    
    lblLabel.text = aText;
}

- (void)setMaxProgressLabelValue:(NSNumber *)aMaxProgressLabelValue {
    
    maxProgressLabelValue = aMaxProgressLabelValue;
    
    lblProgressLabelValue.text = [NSString stringWithFormat:@"%.1f l", [aMaxProgressLabelValue floatValue]];
    [lblProgressLabelValue sizeToFit];
}

- (NSNumber *)maxProgressLabelValue {
    
    return maxProgressLabelValue;
}


-(void)reset
{
    lblProgressLabelValue.text = [NSString stringWithFormat:@"%.1f l", [maxProgressLabelValue floatValue]];
    lblProgressLabelValue.frame = lblProgressLabelValueInitFrame;
    [lblProgressLabelValue sizeToFit];
}

@end
