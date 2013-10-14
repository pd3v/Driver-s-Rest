
#import "ARTProgressView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ARTProgressView

@synthesize maxProgressLabelValue, labelFontSize;

bool fillingUpProgressView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        // self.progress = 1.0;
        
        // lblLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        lblLabel = [[UILabel alloc]init];
        // lblLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        lblLabel.backgroundColor = [UIColor clearColor];

        /*lblProgressLabelValueInitFrame = CGRectMake(self.frame.size.width - 35, self.frame.size.height+2, 35, 15);
        lblProgressLabelValue = [[UILabel alloc]initWithFrame:lblProgressLabelValueInitFrame];*/
        lblProgressLabelValue = [[UILabel alloc]init];
        lblProgressLabelValue.textAlignment = NSTextAlignmentLeft;
        //[lblProgressLabelValue sizeToFit];
        lblProgressLabelValue.backgroundColor = [UIColor clearColor];
        // lblProgressLabelValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        progressionType = ARTDescending;
        

        /*lblProgressLabelValue.layer.borderColor = [[UIColor blackColor]CGColor];
        lblProgressLabelValue.layer.borderWidth = 1;
        // lblProgressLabelValue.layer.cornerRadius = 5.0;*/

        /*lblProgressLabelValue.layer.shadowColor = [[UIColor redColor]CGColor];
        lblProgressLabelValue.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        lblProgressLabelValue.layer.shadowOpacity = 1.0;*/
        
        lblProgressLabelValue.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        lblProgressLabelValue.shadowOffset = CGSizeMake(1.0, 1.0);
        
        /*CGFloat borderWidth = 1.0;
        [[lblProgressLabelValue layer] setBorderWidth:borderWidth];
        
        CALayer *mask = [CALayer layer];
        // The mask needs to be filled to mask
        [mask setBackgroundColor:[[UIColor blackColor] CGColor]];
        // Make the masks frame smaller in height
        CGRect maskFrame = CGRectInset([lblProgressLabelValue bounds], 0, borderWidth);
        // Move the maskFrame to the top
        maskFrame.origin.x = 2;
        mask.frame = maskFrame;
        lblProgressLabelValue.layer.mask = mask;*/

        [self addSubview:(UIView *) lblLabel];
        [self addSubview:(UIView *) lblProgressLabelValue];

        
    }
    return self;
}

- (void)setProgress:(CGFloat)value {
    
    [super progress];
    
    //bool fillingUpProgressView;
    //float static previousValue = 0;

    //lblProgressLabelValueInitFrame = CGRectMake(self.frame.size.width - 35, self.frame.size.height+2, 35, 15);
    //lblProgressLabelValueInitFrame = CGRectMake(0, self.frame.size.height+2, 35, 15);
    //lblProgressLabelValueInitFrame = CGRectMake(0, 0, 0, 0);

    
    //fillingUpProgressView = value >= previousValue ? 1 : 0;
    //previousValue = value;
    
    //NSLog(@"Is ProgressView filling up?:%d", fillingUpProgressView);
    
    progressionType = ARTAscending;
    if (value == 1.0) progressionType = ARTDescending;

    CGRect lblProgressLabelValueFrame = lblProgressLabelValue.frame;
    
    /*if (progressionType == ARTDescending)
    {
        if (lblProgressLabelValue.frame.origin.x >= value * self.frame.size.width)
            lblProgressLabelValueFrame = CGRectMake(value * self.frame.size.width, lblProgressLabelValue.frame.origin.y, lblProgressLabelValue.frame.size.width , lblProgressLabelValue.frame.size.height);
        NSLog(@"Descending");
    }
    else
    {*/
        if (lblProgressLabelValue.frame.origin.x <= value * self.frame.size.width)
            lblProgressLabelValueFrame = CGRectMake(value * self.frame.size.width - lblProgressLabelValue.frame.size.width, lblProgressLabelValue.frame.origin.y, lblProgressLabelValue.frame.size.width , lblProgressLabelValue.frame.size.height);
        NSLog(@"Ascending");
    //}
    
    lblProgressLabelValue.frame = lblProgressLabelValueFrame;
    lblProgressLabelValue.text = [NSString stringWithFormat:@"%.1f", self.progress  * [maxProgressLabelValue floatValue]];
    
    [lblProgressLabelValue sizeToFit];
    
    
    [self setProgress:value animated:TRUE];
}

- (void)setLabel:(NSString *)aText {
    
    lblLabel.text = aText;
    [lblLabel sizeToFit];

    lblLabel.frame = CGRectMake(lblLabel.frame.origin.x, (lblLabel.frame.size.height+(lblLabel.frame.size.height*0.03))*(-1), lblLabel.frame.size.width, lblLabel.frame.size.height);
}

- (void)setMaxProgressLabelValue:(NSNumber *)aMaxProgressLabelValue {
    
    maxProgressLabelValue = aMaxProgressLabelValue;
    
    lblProgressLabelValue.text = [NSString stringWithFormat:@"%.1f", [aMaxProgressLabelValue floatValue]];
    
    [lblProgressLabelValue sizeToFit];
}

- (NSNumber *)maxProgressLabelValue {
    
    return maxProgressLabelValue;
}

- (void)setLabelFontSize:(FontSize)aSize {
    
    lblLabel.font = [UIFont fontWithName:@"Helvetica" size:aSize];
    [lblLabel sizeToFit];
    lblProgressLabelValue.font = [UIFont fontWithName:@"Helvetica" size:aSize];
    [lblProgressLabelValue sizeToFit];
}

/*- (void)setProgressionType:(ProgressionType)progressionType {
    
    _progressionType = progressionType;
    
    lblProgressLabelValueInitFrame = (progressionType == ARTAscending ? CGRectMake(0, 0, 35, 15): CGRectMake(self.frame.size.width - 35, self.frame.size.height+2, 35, 15));
    
}*/

-(void)reset
{
    lblProgressLabelValue.text = [NSString stringWithFormat:@"%.1f", [maxProgressLabelValue floatValue]];
    lblProgressLabelValue.frame = lblProgressLabelValueInitFrame;
    [lblProgressLabelValue sizeToFit];
}

@end
