#import "Car.h"
#import "Driver.h"
#import "ARTProgressView.h"
#import "Velocity.h"

#define CONSUMPTION_PER_100KM 6.0
#define FUEL_TANK_CAPACITY_LITERS 60
#define FULL_FUEL_TANK_HUE 0.36
#define RESTING_TIME_MIN 240
#define TIME_HOLDER_SEC 0.02 // Not a Car property. Declaring it as a macro/const.
#define SECONDS_TO_MINUTES 60
#define MINUTES_TO_HOURS 60

@implementation Car

@synthesize maxSpeed, maxAcceleration, distanceTraveled, fuelTank;
@synthesize fuelConsumptionPerKm, tankCapacityLiters, speed, fullFuelTankHue, restingTimeMin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        driver = [[Driver alloc]init];
        
        fuelConsumptionPerKm = CONSUMPTION_PER_100KM/100;
        tankCapacityLiters = FUEL_TANK_CAPACITY_LITERS;
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

- (void)setMaxSpeed:(CGFloat)aMaxSpeed
{
    maxSpeed = aMaxSpeed/60; //Distance covered in minutes;
}

- (void)setMaxAcceleration:(CGFloat)aMaxAcceleration
{
    maxAcceleration = aMaxAcceleration;
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
        hue -= fullFuelTankHue / ((tankCapacityLiters * SECONDS_TO_MINUTES) / (speed * fuelConsumptionPerKm));
        
        progviewFuelTank.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1.0];
    });
}

- (void)goTrip
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSUInteger tripTime = [driver.drivingTime intValue];
        CGFloat consumedFuel = (1.0 - fuelTank) * tankCapacityLiters;

        CGFloat nowSpeed = 0, previousSpeed;
        
        while (fuelTank > 0.0 && fuelTank <= 1.0 && !tripCancelled) {
            
            [NSThread sleepForTimeInterval:TIME_HOLDER_SEC];
            
            // 1.38m/s2 <=> From 0Km/h to 100Km/h in 20s
            CGFloat acceleration = [[velocity acceleration:[NSNumber numberWithFloat:maxAcceleration]]intValue];
            //NSLog(@"acceleration=%fKm/min2", acceleration*60/1000);

            nowSpeed = previousSpeed + acceleration * SECONDS_TO_MINUTES / 1000; // Km/min
            
            // Speed limits
            if (nowSpeed < 0.0) nowSpeed = 0.0;
            else if (nowSpeed >= maxSpeed) nowSpeed = maxSpeed;
            
            previousSpeed = nowSpeed;
            
            // NSLog (@"[self fuelConsumptionPerKm:nowSpeed]=%f", [self fuelConsumptionPerKm:nowSpeed]);
            consumedFuel +=  nowSpeed * [self fuelConsumptionPerKm:nowSpeed] /*/ SECONDS_TO_MINUTES*/;
            distanceTraveled = [NSNumber numberWithFloat:[distanceTraveled floatValue] + nowSpeed];
            
            fuelTank = 1.0 - (consumedFuel / tankCapacityLiters);
            // Left fuel is all car should spend, no fuel reserve
            if (fuelTank < 0.0) fuelTank = 0.0;
            // NSLog (@"fuelTank=%fl consumedFuel=%fl leftFuel=%f nowSpeed=%.2fKm/h distanceTravelled=%f", fuelTank, consumedFuel, (consumedFuel / tankCapacityLiters), nowSpeed*60, [distanceTraveled floatValue]);

            tripTime += 1; // minutes
            speed = nowSpeed * MINUTES_TO_HOURS; // Km/h
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
    });
}

- (void)stopTrip
{
    tripCancelled = YES;
}

- (void)restartTrip
{
    fuelTank = 1.0;
    speed = 0;
    distanceTraveled = [NSNumber numberWithFloat:0.0];
    driver.drivingTime = [NSNumber numberWithInt:0];
    
    progviewFuelTank.progress = 1.0;
    progviewFuelTank.maxValue = [NSNumber numberWithFloat:tankCapacityLiters];
    progviewFuelTank.progressTintColor = [UIColor colorWithHue:fullFuelTankHue saturation:0.88 brightness:0.88 alpha:1.0];

    [progviewFuelTank reset];
}

- (CGFloat)fuelConsumptionPerKm:(CGFloat)speed
{
    // Constant fuel consumption, independent from car acceleration - unreal
    CGFloat fuelConsumption = fuelConsumptionPerKm;
    
    return fuelConsumption;
}

@end

