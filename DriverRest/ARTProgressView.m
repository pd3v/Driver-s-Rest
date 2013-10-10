
#import "ARTProgressView.h"

@implementation ARTProgressView

@synthesize maxLabelValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.progress = 1.0;
        
        lblLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-18, frame.size.width, 15)];
        lblLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        lblLabel.backgroundColor = [UIColor clearColor];
        
        // progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

        
        lblProgressValueInitFrame = CGRectMake(self.frame.size.width - 35, self.frame.size.height+2, 35, 15);
        lblProgressValue = [[UILabel alloc]initWithFrame:lblProgressValueInitFrame];
        lblProgressValue.textAlignment = NSTextAlignmentLeft;
        [lblProgressValue sizeToFit];
        lblProgressValue.backgroundColor = [UIColor clearColor];
        lblProgressValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        
        [self addSubview:(UIView *) lblLabel];
        // [self addSubview:(UIView *) progressView];
        [self addSubview:(UIView *) lblProgressValue];
    }
    return self;
}

- (void)setProgress:(CGFloat)value {
    
    [super progress];
    
    CGRect lblProgressValueFrame = lblProgressValue.frame;
    
    if (lblProgressValue.frame.origin.x >= value * self.frame.size.width)
        lblProgressValueFrame = CGRectMake(value * self.frame.size.width, lblProgressValue.frame.origin.y, lblProgressValue.frame.size.width , lblProgressValue.frame.size.height);
    
    lblProgressValue.frame = lblProgressValueFrame;
    lblProgressValue.text = [NSString stringWithFormat:@"%.1f l", self.progress  * [maxLabelValue floatValue]];
    [lblProgressValue sizeToFit];
    
    [self setProgress:value animated:TRUE];
}

/*- (NSNumber *)progressTintColor {
    
    CGFloat hue;
    UIColor *cor = progressView.progressTintColor;
    [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
    
    return [NSNumber numberWithFloat:hue];
}*/

/*- (void)setProgressTintColor:(NSNumber *)hue {
    
    progressView.progressTintColor = [UIColor colorWithHue:[hue floatValue] saturation:0.88 brightness:0.88 alpha:1.0];
}*/

- (void)setLabel:(NSString *)aText {
    
    lblLabel.text = aText;
}


- (void)setMaxLabelValue:(NSNumber *)amaxLabelValue {
    
    maxLabelValue = amaxLabelValue;
    
    lblProgressValue.text = [NSString stringWithFormat:@"%.1f l", [amaxLabelValue floatValue]];
    [lblProgressValue sizeToFit];
}

- (NSNumber *)maxLabelValue {
    
    return maxLabelValue;
}


-(void)reset
{
    lblProgressValue.text = [NSString stringWithFormat:@"%.1f l", [maxLabelValue floatValue]];
    lblProgressValue.frame = lblProgressValueInitFrame;
    [lblProgressValue sizeToFit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
