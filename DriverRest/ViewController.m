
#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bttGo.hidden = NO;
    bttStop.hidden = YES;
    bbttiRestartTrip.style = UIBarButtonItemStylePlain;
    bbttiRestartTrip.enabled = NO;
    
    car = [[Car alloc] initWithFrame:self.view.bounds];
    car.delegate = self;
    [car addObserver:self forKeyPath:@"driver.drivingTime" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view insertSubview:car atIndex:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"driver.drivingTime"])
    {
        
        lblTripTime.text = [self fromTimeIntToTimeHHmmss:[change objectForKey:NSKeyValueChangeNewKey]];
     
        NSUInteger newTime = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        
        if (newTime != 0 && newTime % [[car valueForKeyPath:@"driver.restingTime"] intValue] == 0)
        {
            UIColor *red = [UIColor redColor];
           
            bttGo.hidden = NO;
            bttStop.hidden = YES;
            
            for (id eachView in [self.view subviews])
                //if (![eachView isKindOfClass:[UIButton class]])
                    [eachView setBackgroundColor:red];
        }
        else
        {
            
            UIColor *white = [UIColor whiteColor];
            
            for (id eachView in [self.view subviews])
                    [eachView setBackgroundColor:white];
        }
    }

}

- (NSString*)fromTimeIntToTimeHHmmss:(NSNumber*)aTime
{
    NSDateComponents* timeMinutes = [[NSDateComponents alloc] init];
    
    [timeMinutes setMinute:[aTime intValue]];
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate* aDate = [calendar dateFromComponents:timeMinutes];
    
    NSDateComponents* clock = [calendar components:NSHourCalendarUnit |
                                 NSMinuteCalendarUnit |
                                 NSSecondCalendarUnit
                                              fromDate:aDate];
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",[clock hour], [clock minute], [clock second]];
}

- (IBAction)goingOnATrip:(id)sender
{
    bttGo.hidden = YES;
    bttStop.hidden = NO;
    
    [car updateTripTimeFuelTank];
}

- (IBAction)stopTrip:(id)sender
{
    [car stopTrip];
    
    bttGo.hidden = NO;
    bttStop.hidden = YES;
}



- (IBAction)restartTrip:(id)sender
{
    bbttiRestartTrip.enabled = NO;

    bttGo.hidden = NO;
    bttGo.enabled = YES;
    bttStop.hidden = YES;
    
    [car restartTrip];
    
    lblTripTime.text = [self fromTimeIntToTimeHHmmss:[car valueForKeyPath:@"driver.drivingTime"]];
}

- (void)carRanOutOfFuel
{
    bbttiRestartTrip.enabled = YES;
    
    bttStop.hidden = YES;
    bttGo.hidden = NO;
    bttGo.enabled = NO;
}

- (void)dealloc
{
    [car removeObserver:self forKeyPath:@"driver.drivingTime"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

