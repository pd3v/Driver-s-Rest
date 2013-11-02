
#import "ViewController.h"

#define CONSUMPTION_PER_100KM 6.0

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *borderColor = [UIColor colorWithHue:0.58 saturation:0.98 brightness:1.0 alpha:1.0];
    bttGo.layer.borderColor = borderColor.CGColor;
    bttGo.layer.borderWidth = 1.0;
    bttGo.hidden = NO;
    bttStop.layer.borderColor = borderColor.CGColor;
    bttStop.layer.borderWidth = 1.0;
    bttStop.hidden = YES;
    bbttiRestartTrip.style = UIBarButtonItemStylePlain;
    bbttiRestartTrip.enabled = NO;
    
    car = [[Car alloc] initWithFrame:self.view.bounds];
    car.maxSpeedKmH = 220;
    car.maxAccelerationMtrSec2 = 1.38; // 1.38m/s2 => From 0Km/h to 100Km/h in 20s
    car.fuelConsumptionPerKm = CONSUMPTION_PER_100KM/100;
    car.tankCapacityLiters = 60;
    car.fullFuelTankHue = 0.36;
    car.driversRestingTimeMin = 120;
    car.delegate = self;
    
    [car addObserver:self forKeyPath:@"driver.drivingTimeMin" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view insertSubview:car atIndex:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"driver.drivingTimeMin"])
    {
        
        lblTripTime.text = [self fromTimeIntToTimeHHmmss:[change objectForKey:NSKeyValueChangeNewKey]];
        lblSpeed.text = [NSString stringWithFormat:@"%d", [[car valueForKey:@"speedKmH"] intValue]]; // Km/h
        lblDistanceTraveled.text = [NSString stringWithFormat:@"%.1f", [[car valueForKey:@"distanceTraveledKm"] floatValue]]; //Km
        NSUInteger newTime = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        
        if (newTime != 0 && newTime % [[car valueForKeyPath:@"driver.restingTimeMin"] intValue] == 0)
        {
            UIColor *red = [UIColor colorWithRed:0.85 green:0.0 blue:0.0 alpha:1.0];
           
            bttGo.hidden = NO;
            bttStop.hidden = YES;
            
            for (id eachView in [self.view subviews])
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
    
    [car goTrip];
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
    
    lblTripTime.text = [self fromTimeIntToTimeHHmmss:[car valueForKeyPath:@"driver.drivingTimeMin"]];
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
    [car removeObserver:self forKeyPath:@"driver.drivingTimeMin"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

