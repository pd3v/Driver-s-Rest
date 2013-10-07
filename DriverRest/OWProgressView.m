
#import "OWProgressView.h"

@implementation OWProgressView

@synthesize progressValue, progressTintColor, description, maxValue;

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
        
        lblProgressValue = [[UILabel alloc]initWithFrame:
                            CGRectMake(frame.size.width - 35, progressView.frame.size.height+2, 35, 15)];
        lblProgressValue.textAlignment = NSTextAlignmentLeft;
        [lblProgressValue sizeToFit];
        lblProgressValue.backgroundColor = [UIColor clearColor];

        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        lblProgressValue.font = font;
        
        // max = [[NSMutableArray alloc]init];
  
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[progressView setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        lblProgressValue.frame = lblProgressValueFrame;
        [lblProgressValue sizeToFit];
        //NSLog(@"lblProgressValue.frame:%.2f value:%.2f", lblProgressValue.frame.origin.x, [value floatValue] * progressView.frame.size.width);
        // NSLog(@"lblProgressValue.text = %@", /*[NSString stringWithFormat:@"%.2f l", progressView.progress]*/ [NSString stringWithFormat:@"%d", [maxValue intValue]]);
        // lblProgressValue.text = [NSString stringWithFormat:@"%.f l", progressView.progress  * [[max objectAtIndex:0] intValue]];
        lblProgressValue.text = [NSString stringWithFormat:@"%.1f l", progressView.progress  * [maxValue intValue]];

        progressView.progress = [value floatValue];
        //[myProgDeposito.progress setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        //myProgDeposito.numProgress=[change objectForKey:NSKeyValueChangeNewKey];
    });
}

- (NSNumber *)progressTintColor {
    
    CGFloat hue;
    UIColor *cor = progressView.progressTintColor;
    [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
    
    return [NSNumber numberWithFloat:hue];
}

- (void)setProgressTintColor:(NSNumber *)hue {
    
    // NSLog(@"hue = %.2f", [hue floatValue]);
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.progressTintColor = [UIColor colorWithHue:[hue floatValue] saturation:0.88 brightness:0.88 alpha:1.0];
    });
}

- (void)setDescription:(NSString *)aDescription {
    
    lblDescription.text = aDescription;
}


- (void)setMaxValue:(NSNumber *)amaxValue {
    
    // [max addObject:amaxValue];
    maxValue = amaxValue;
    // NSLog(@"max array:%@", [max objectAtIndex:0]);
    // lblProgressValue.text = [NSString stringWithFormat:@"%d l", [[max objectAtIndex:0] intValue]];
    lblProgressValue.text = [NSString stringWithFormat:@"%.1f l", [amaxValue floatValue]];
    //lblProgressValue.frame = CGRectMake(self.frame.size.width - 26, progressView.frame.size.height+2, 50, 15);
}

- (NSNumber *)maxValue {
    
    return maxValue;
}


-(void)reset
{
    // maxValue = [NSNumber numberWithInt:[[max objectAtIndex:0] intValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // lblProgressValue.text = [NSString stringWithFormat:@"%d l", [[max objectAtIndex:0] intValue]];
        lblProgressValue.text = [NSString stringWithFormat:@"%.1f l", [maxValue floatValue]];
        lblProgressValue.frame = CGRectMake(self.frame.size.width - 35, progressView.frame.size.height+2, 35, 15);
        [lblProgressValue sizeToFit];
    });
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
