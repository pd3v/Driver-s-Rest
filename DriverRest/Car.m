#import "Car.h"
#import "Driver.h"
#import "ARTProgressView.h"
#import "Velocity.h"

#define CONSUMPTION_PER_100KM 6.0
#define FUEL_TANK_CAPACITY_LITERS 60
// #define SPEED_KM_H 100 // Keeping it on a steady pace. Better move out of the way! :)
#define FULL_FUEL_TANK_HUE 0.36
#define RESTING_TIME_MIN 1000
#define TIME_HOLDER_SEC 0.02 // Not a Car property. Declaring it as a macro/const.
#define SECONDS_TO_MINUTES 60

@implementation Car

@synthesize fuelTank;
@synthesize fuelConsumptionPerKm, tankCapacityLiters, speedKmH, fullFuelTankHue, restingTimeMin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        driver = [[Driver alloc]init];
        
        fuelConsumptionPerKm = CONSUMPTION_PER_100KM/100;
        tankCapacityLiters = FUEL_TANK_CAPACITY_LITERS;
        // speedKmH = SPEED_KM_H;
        fullFuelTankHue = FULL_FUEL_TANK_HUE;
        restingTimeMin = RESTING_TIME_MIN;
        
        driver.drivingTime = [NSNumber numberWithInt:0];
        driver.restingTime = [NSNumber numberWithInt:restingTimeMin];
        fuelTank = 1.0;
        
        velocity = [Velocity create];
        
        progviewFuelTank = [[ARTProgressView alloc]initWithFrame:CGRectMake(20, 395, 280, 50)];
        progviewFuelTank.progressTintColor = [UIColor colorWithHue:fullFuelTankHue saturation:0.88 brightness:0.88 alpha:1.0];
        progviewFuelTank.font = [UIFont fontWithName:@"Helvetica" size:ARTMediumSizeFont];
        progviewFuelTank.label = @"Fuel";
        progviewFuelTank.valueSuffix = @"L";
        progviewFuelTank.progress = 1.0;
        progviewFuelTank.maxValue = [NSNumber numberWithFloat:tankCapacityLiters];

        self.userInteractionEnabled = NO;
        [self addSubview:(UIView *)progviewFuelTank];
    }
    return self;
}

- (void)setFuelTank:(CGFloat)aFuelTank
{
    fuelTank = aFuelTank;
    
    if (aFuelTank == 0.0)
        dispatch_sync(dispatch_get_main_queue(), ^{ [self.delegate carRanOutOfFuel]; });
    if (aFuelTank > 0.0)
    dispatch_sync(dispatch_get_main_queue(), ^{
        CGFloat hue;
        UIColor *cor = progviewFuelTank.progressTintColor;
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
        hue -= fullFuelTankHue / ((tankCapacityLiters * SECONDS_TO_MINUTES) / (speedKmH * fuelConsumptionPerKm));
        
        progviewFuelTank.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1.0];
    });
}

- (void)goTrip
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSUInteger tripTime = [driver.drivingTime intValue];
        
        CGFloat consumedFuel = (1.0 - fuelTank) * tankCapacityLiters;
        NSLog (@"Consumed Fuel=%f self.fuelTank=%f", consumedFuel, self.fuelTank);
        NSUInteger distanceTravelled = 0;
        
        CGFloat nowSpeed = 0, previousSpeed;
        
        while (fuelTank > 0.0 && fuelTank <= 1.0 && !tripCancelled) {
            
            [NSThread sleepForTimeInterval:TIME_HOLDER_SEC];
            
            NSUInteger acceleration = [[velocity acceleration:[NSNumber numberWithInt:10]]intValue];
            
            // consumedFuel = tripTime * spd * fuelConsumptionPerKm / SECONDS_TO_MINUTES;
            nowSpeed = previousSpeed + acceleration;
            nowSpeed = nowSpeed < 0 ? 0 : nowSpeed;
            previousSpeed = nowSpeed;
            // NSLog (@"[self fuelConsumptionPerKm:nowSpeed]=%f", [self fuelConsumptionPerKm:nowSpeed]);
            consumedFuel +=  nowSpeed * [self fuelConsumptionPerKm:nowSpeed] / SECONDS_TO_MINUTES;
            //distanceTravelled = tripTime * nowSpeed / SECONDS_TO_MINUTES; // Variable not used. Just info.
            distanceTravelled += tripTime * nowSpeed / SECONDS_TO_MINUTES; // Variable not used. Just info.
            fuelTank = 1.0 - (consumedFuel / tankCapacityLiters);
            fuelTank = fuelTank < 0.0 ? 0.0 : fuelTank;
            NSLog (@"fuelTank=%f consumedFuel=%f nowSpeed=%f distanceTravelled=%d", fuelTank, consumedFuel, nowSpeed, distanceTravelled);
            // fuelTank = (consumedFuelTotal / tankCapacityLiters);

            tripTime += 1; // trip time in minutes
            
            self.fuelTank = fuelTank;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                // NSLog(@"Speed:%f Consumed Fuel/min:%f Consumed Fuel Total:%f fuelTank:%f", nowSpeed, (nowSpeed * fuelConsumptionPerKm)/SECONDS_TO_MINUTES, consumedFuel, fuelTank);
                
                driver.drivingTime = [NSNumber numberWithInt:tripTime];
                progviewFuelTank.progress = fuelTank;
            });
            
            if ((tripTime % [driver.restingTime intValue] == 0 && tripTime != 0))
                break;
        }
        
        tripCancelled = NO;
        consumedFuel = 0.0;
    });
}

- (void)stopTrip
{
    tripCancelled = YES;
}

- (void)restartTrip
{
    fuelTank = 1.0;
    driver.drivingTime = [NSNumber numberWithInt:0];
    
    progviewFuelTank.progress = 1.0;
    progviewFuelTank.maxValue = [NSNumber numberWithFloat:tankCapacityLiters];
    progviewFuelTank.progressTintColor = [UIColor colorWithHue:fullFuelTankHue saturation:0.88 brightness:0.88 alpha:1.0];

    [progviewFuelTank reset];
}

- (CGFloat)fuelConsumptionPerKm:(CGFloat)speed
{
    // Constant fuel consumption, independent from car speed - unreal
    CGFloat fuelConsumption = fuelConsumptionPerKm;
    
    // CGFloat fuelConsumption = (pow(2,speed/18)*1/25)/100;
    
    return fuelConsumption;
}

@end

