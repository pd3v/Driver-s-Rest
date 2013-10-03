
#import "OWProgressView.h"

#define CONSUMO_POR_KM 0.06
#define DEPOSITO_CHEIO_LITROS 60
#define VELOCIDADE_KM_H 100
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO 120
#define TIME_HOLDER_SEC 0.005

@implementation OWProgressView {
    CGFloat depositoCheio;
}

@synthesize progressValue, progressTintColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setFrame:frame];
        
        progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        // progressView.progressTintColor = [UIColor colorWithHue:DEPOSITO_CHEIO_HUE saturation:0.88 brightness:0.88 alpha:1];
        progressView.progress = 1.0;
        
        depositoCheio = DEPOSITO_CHEIO_LITROS;
        
        lblProgressValue = [[UILabel alloc]initWithFrame:
                            CGRectMake(frame.size.width - 26, progressView.frame.size.height+2, 30, 15)];
        lblProgressValue.backgroundColor = [UIColor clearColor];
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        lblProgressValue.font = font;
        
        lblProgressValue.text = [NSString stringWithFormat:@"%.f l", depositoCheio];
        
        [self addSubview:(UIView *) progressView];
        [self addSubview:(UIView *) lblProgressValue];
        
    }
    return self;
}


- (void)setProgressValue:(NSNumber *)value {
    
    
    /*CGRect lblProgressValueFrame = viewDeposito.progressValue.frame;
    if (lblProgressValue.frame.origin.x >= [[change objectForKey:NSKeyValueChangeNewKey] floatValue] * progressView.frame.size.width)
        lblProgressValueFrame = CGRectMake([[change objectForKey:NSKeyValueChangeNewKey] floatValue] * progressView.frame.size.width, lblProgressValue.frame.origin.y, lblProgressValue.frame.size.width, lblProgressValue.frame.size.height);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressView setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        lblProgressValue.frame = lblProgressValueFrame;
        lblProgressValue.text = [NSString stringWithFormat:@"%.f l", progressView.progress*DEPOSITO_CHEIO_LITROS];
        //[myProgDeposito.progress setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        //myProgDeposito.numProgress=[change objectForKey:NSKeyValueChangeNewKey];
    });*/
    
    CGRect lblProgressValueFrame = lblProgressValue.frame;
    // NSLog(@"self.frame:%@", NSStringFromCGRect(lblProgressValueFrame));
    if (lblProgressValue.frame.origin.x >= [value floatValue] * self.frame.size.width)
        lblProgressValueFrame = CGRectMake([value floatValue] * progressView.frame.size.width, lblProgressValue.frame.origin.y, lblProgressValue.frame.size.width, lblProgressValue.frame.size.height);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[progressView setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        lblProgressValue.frame = lblProgressValueFrame;
        //NSLog(@"lblProgressValue.frame:%.2f value:%.2f", lblProgressValue.frame.origin.x, [value floatValue] * progressView.frame.size.width);
        lblProgressValue.text = [NSString stringWithFormat:@"%.f l", progressView.progress * depositoCheio];
        progressView.progress = [value floatValue];
        //[myProgDeposito.progress setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        //myProgDeposito.numProgress=[change objectForKey:NSKeyValueChangeNewKey];
    });


    
    /*dispatch_async(dispatch_get_main_queue(), ^{
        progressView.progress = [value floatValue];
    });*/
}

- (UIColor *)progressTintColor {
    return progressView.progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)hue {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.progressTintColor = hue;
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




-(void)resetToProgress:(NSNumber *)progress andHue:(NSNumber *)hue
{
    lblProgressValue.frame = CGRectMake(self.frame.size.width - 26, progressView.frame.size.height + 2, 30, 15);
    lblProgressValue.text = [NSString stringWithFormat:@"%.f", depositoCheio];
    self.progressValue = progress;
    progressView.progressTintColor = [UIColor colorWithHue:[hue floatValue] saturation:0.88 brightness:0.88 alpha:1.0];
}


@end
