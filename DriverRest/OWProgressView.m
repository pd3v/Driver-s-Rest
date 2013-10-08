
#import "OWProgressView.h"

@implementation OWProgressView

@synthesize progressValue, progressTintColor, description, maxLabelValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;

        lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(0, progressView.frame.size.height-18, frame.size.width, 15)];
        lblDescription.font = [UIFont fontWithName:@"Helvetica" size:13];
        lblDescription.backgroundColor = [UIColor clearColor];
        
        progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        progressView.progress = 1.0;
        
        lblProgressValueInitFrame = CGRectMake(frame.size.width - 35, progressView.frame.size.height+2, 35, 15);
        lblProgressValue = [[UILabel alloc]initWithFrame:lblProgressValueInitFrame];
        lblProgressValue.textAlignment = NSTextAlignmentLeft;
        [lblProgressValue sizeToFit];
        lblProgressValue.backgroundColor = [UIColor clearColor];
        lblProgressValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
  
        [self addSubview:(UIView *) lblDescription];
        [self addSubview:(UIView *) progressView];
        [self addSubview:(UIView *) lblProgressValue];
        
    }
    return self;
}


- (void)setProgressValue:(NSNumber *)value {
    
    CGRect lblProgressValueFrame = lblProgressValue.frame;
    
    if (lblProgressValue.frame.origin.x >= [value floatValue] * self.frame.size.width)
        lblProgressValueFrame = CGRectMake([value floatValue] * progressView.frame.size.width, lblProgressValue.frame.origin.y, lblProgressValue.frame.size.width , lblProgressValue.frame.size.height);
    
    lblProgressValue.frame = lblProgressValueFrame;
    lblProgressValue.text = [NSString stringWithFormat:@"%.1f l", progressView.progress  * [maxLabelValue floatValue]];
    [lblProgressValue sizeToFit];

    [progressView setProgress:[value floatValue] animated:TRUE];
}

- (NSNumber *)progressTintColor {
   
    CGFloat hue;
    UIColor *cor = progressView.progressTintColor;
    [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
    
    return [NSNumber numberWithFloat:hue];
}

- (void)setProgressTintColor:(NSNumber *)hue {
    
    progressView.progressTintColor = [UIColor colorWithHue:[hue floatValue] saturation:0.88 brightness:0.88 alpha:1.0];
}

- (void)setDescription:(NSString *)aDescription {
    
    lblDescription.text = aDescription;
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
