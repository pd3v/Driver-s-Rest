
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
                            CGRectMake(frame.size.width - 26, progressView.frame.size.height+2, 30, 15)];
        lblProgressValue.backgroundColor = [UIColor clearColor];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        lblProgressValue.font = font;
        lblProgressValue.text = [NSString stringWithFormat:@"%@ l", maxValue];
  
        [self addSubview:(UIView *) lblDescription];
        [self addSubview:(UIView *) progressView];
        [self addSubview:(UIView *) lblProgressValue];
        
        [self addObserver:self forKeyPath:@"description" options:NSKeyValueObservingOptionNew context:NULL];
        // [self addObserver:self forKeyPath:@"maxValue" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    return self;
}


- (void)setProgressValue:(NSNumber *)value {
    
    CGRect lblProgressValueFrame = lblProgressValue.frame;
    
    if (lblProgressValue.frame.origin.x >= [value floatValue] * self.frame.size.width)
        lblProgressValueFrame = CGRectMake([value floatValue] * progressView.frame.size.width, lblProgressValue.frame.origin.y, lblProgressValue.frame.size.width, lblProgressValue.frame.size.height);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[progressView setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        lblProgressValue.frame = lblProgressValueFrame;
        //NSLog(@"lblProgressValue.frame:%.2f value:%.2f", lblProgressValue.frame.origin.x, [value floatValue] * progressView.frame.size.width);
        lblProgressValue.text = [NSString stringWithFormat:@"%.f l", progressView.progress * [maxValue intValue]];
        progressView.progress = [value floatValue];
        //[myProgDeposito.progress setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        //myProgDeposito.numProgress=[change objectForKey:NSKeyValueChangeNewKey];
    });


    
    /*dispatch_async(dispatch_get_main_queue(), ^{
        progressView.progress = [value floatValue];
    });*/
}

- (NSNumber *)progressTintColor {
    
    CGFloat hue;
    UIColor *cor = progressView.progressTintColor;
    [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
    
    return [NSNumber numberWithFloat:hue];
}

- (void)setProgressTintColor:(NSNumber *)hue {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.progressTintColor = [UIColor colorWithHue:[hue floatValue] saturation:0.88 brightness:0.88 alpha:1.0];
    });
}

- (void)setMaxValue:(NSNumber *)amaxValue {
    
    lblProgressValue.text = [NSString stringWithFormat:@"%@ l", amaxValue];
    lblProgressValue.frame = CGRectMake(self.frame.size.width - 26, progressView.frame.size.height+2, 30, 15);
}

- (NSNumber *)maxValue {
    
    return maxValue;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"description"])
        lblDescription.text = description;
    
    /*if ([keyPath isEqualToString:@"maxValue"])
    {


        NSLog(@"self.frame:%@", NSStringFromCGRect(self.frame));
        NSLog(@"lblProgressValue.frame:%@", NSStringFromCGRect(lblProgressValue.frame));
    }*/
}

-(void)reset:(NSNumber *)progress max:(NSNumber *)max hue:(NSNumber *)hue
{
    //lblProgressValue.text = [NSString stringWithFormat:@"%d", 60];
    //self.maxValue = max;
    //lblProgressValue.frame = CGRectMake(self.frame.size.width - 26, progressView.frame.size.height + 2, 30, 15);

    //progressView.progressTintColor = [UIColor colorWithHue:[hue floatValue] saturation:0.88 brightness:0.88 alpha:1.0];
    //self.progressValue = progress;
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
