
#import "ARTProgressView.h"

@implementation ARTProgressView

@synthesize maxValue, valueSuffix, font;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        font = [[UIFont alloc]init];
        
        lblLabel = [[UILabel alloc]init];
        lblLabel.backgroundColor = [UIColor clearColor];

        lblProgressLabelValueInitFrame = CGRectMake(self.frame.size.width - 35, self.frame.size.height+2, 35, 15);
        lblValue = [[UILabel alloc]initWithFrame:lblProgressLabelValueInitFrame];
        lblValue.textAlignment = NSTextAlignmentLeft;
        lblValue.backgroundColor = [UIColor clearColor];
        lblValue.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        lblValue.shadowOffset = CGSizeMake(1.0, 1.0);
        
        [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:NULL];
    
        [self addSubview:(UIView *) lblLabel];
        [self addSubview:(UIView *) lblValue];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"font"])
    {
        lblLabel.font = [change objectForKey:NSKeyValueChangeNewKey];
        lblValue.font = [change objectForKey:NSKeyValueChangeNewKey];
    }
    
}

- (void)setProgress:(CGFloat)value {
    
    [super progress];
    
    CGRect lblProgressLabelValueFrame = lblValue.frame;
    
    if (lblValue.frame.origin.x >= value * self.frame.size.width)
        lblProgressLabelValueFrame = CGRectMake(value * self.frame.size.width, lblValue.frame.origin.y, lblValue.frame.size.width , lblValue.frame.size.height);
    
    lblValue.frame = lblProgressLabelValueFrame;
    lblValue.text = [NSString stringWithFormat:@"%.1f%@", value  * [maxValue floatValue], valueSuffix];
    
    [lblValue sizeToFit];
    
    [self setProgress:value animated:TRUE];
}

- (void)setLabel:(NSString *)aText {
    
    lblLabel.text = aText;
    [lblLabel sizeToFit];

    lblLabel.frame = CGRectMake(lblLabel.frame.origin.x, (lblLabel.frame.size.height+(lblLabel.frame.size.height*0.03))*(-1), lblLabel.frame.size.width, lblLabel.frame.size.height);
}

- (void)setMaxValue:(NSNumber *)aMaxValue {
    
    maxValue = aMaxValue;
    
    lblValue.text = [NSString stringWithFormat:@"%.1f%@", [aMaxValue floatValue], valueSuffix];
    lblValue.frame = lblProgressLabelValueInitFrame;
    [lblValue sizeToFit];
}

- (NSNumber *)maxValue {
    
    return maxValue;
}

- (void)setLabelsFontSize:(FontSize)aSize {
    
    lblLabel.font = [UIFont fontWithName:@"Helvetica" size:aSize];
    [lblLabel sizeToFit];
    
    lblValue.font = [UIFont fontWithName:@"Helvetica" size:aSize];
    [lblValue sizeToFit];
}

-(void)reset
{
    lblValue.text = [NSString stringWithFormat:@"%.1f%@", [maxValue floatValue], self.valueSuffix];
    lblValue.frame = lblProgressLabelValueInitFrame;
    [lblValue sizeToFit];
}

@end
