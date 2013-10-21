#import "Car.h"
#import "Driver.h"
#import "ARTProgressView.h"
#import "AccelerationFactory.h"

#define TIME_HOLDER_SEC 0.02 // Delay goTrip Loop for simulating purposes
#define SECONDS_TO_MINUTES 60
#define MINUTES_TO_HOURS 60

@implementation Car

@synthesize maxSpeedKmH, maxAccelerationMtrSec2, fuelConsumptionPerKm,  tankCapacityLiters, fullFuelTankHue,  driversRestingTimeMin;
@synthesize speedKmH, distanceTraveledKm, fuelTank;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        driver = [[Driver alloc]init];
    
        carAcceleration = [AccelerationFactory create];
        
        fuelTank = 1.0;
        
        progviewFuelTank = [[ARTProgressView alloc]initWithFrame:CGRectMake(20, 395, 280, 50)];
        progviewFuelTank.font = [UIFont fontWithName:@"Helvetica" size:ARTMediumSizeFont];
        progviewFuelTank.label = @"Fuel";
        progviewFuelTank.valueSuffix = @"L";
        progviewFuelTank.progress = 1.0;

        self.userInteractionEnabled = NO;
        [self addSubview:(UIView *)progviewFuelTank];
    }
    return self;
}

- (void)setMaxSpeedKmH:(CGFloat)aMaxSpeedKmH
{
    maxSpeedKmH = aMaxSpeedKmH/60; // Km/min
}

- (void)setMaxAccelerationMtrSec2:(CGFloat)aMaxAccelerationMtrSec2
{
    maxAccelerationMtrSec2 = aMaxAccelerationMtrSec2;
}

- (void)setFullFuelTankHue:(CGFloat)aFullFuelTankHue
{
    fullFuelTankHue = aFullFuelTankHue;
    progviewFuelTank.progressTintColor = [UIColor colorWithHue:aFullFuelTankHue saturation:0.88 brightness:0.88 alpha:1.0];
}

- (void)setTankCapacityLiters:(NSUInteger)aTankCapacityLiters
{
    tankCapacityLiters = aTankCapacityLiters;
    progviewFuelTank.maxValue = [NSNumber numberWithFloat:aTankCapacityLiters];
}

- (void)setDriversRestingTimeMin:(NSUInteger)aDriversRestingTimeMin
{
    driversRestingTimeMin = aDriversRestingTimeMin;
    driver.restingTimeMin = [NSNumber numberWithInt:aDriversRestingTimeMin];
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
        
        NSUInteger tripTime = [driver.drivingTimeMin intValue];
        CGFloat consumedFuel = (1.0 - fuelTank) * tankCapacityLiters;
        CGFloat nowSpeed = 0, previousSpeed, acceleration;

        while (fuelTank > 0.0 && fuelTank <= 1.0 && !tripCancelled) {
            
            [NSThread sleepForTimeInterval:TIME_HOLDER_SEC];

            acceleration = [[carAcceleration acceleration:[NSNumber numberWithFloat:maxAccelerationMtrSec2]]intValue];
            nowSpeed = previousSpeed + acceleration * SECONDS_TO_MINUTES / 1000; // Km/min
            
            // Speed limits
            if (nowSpeed < 0.0) nowSpeed = 0.0;
            else if (nowSpeed >= maxSpeedKmH) nowSpeed = maxSpeedKmH;
    
            previousSpeed = nowSpeed;
            
            consumedFuel +=  nowSpeed * [self fuelConsumptionPerKm:nowSpeed];
            distanceTraveledKm = [NSNumber numberWithFloat:[distanceTraveledKm floatValue] + nowSpeed];
            
            fuelTank = 1.0 - (consumedFuel / tankCapacityLiters);
            // Left fuel is all car should spend. There's no fuel reserve
            if (fuelTank < 0.0) fuelTank = 0.0;
    
            tripTime += 1; // minutes
            speedKmH = nowSpeed * MINUTES_TO_HOURS; // Km/h
            self.fuelTank = fuelTank;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                driver.drivingTimeMin = [NSNumber numberWithInt:tripTime];
                progviewFuelTank.progress = fuelTank;
            });
            
            if ((tripTime % [driver.restingTimeMin intValue] == 0 && tripTime != 0))
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
    speedKmH = 0;
    distanceTraveledKm = [NSNumber numberWithFloat:0.0];
    driver.drivingTimeMin = [NSNumber numberWithInt:0];
    
    progviewFuelTank.progress = 1.0;
    progviewFuelTank.maxValue = [NSNumber numberWithFloat:tankCapacityLiters];
    progviewFuelTank.progressTintColor = [UIColor colorWithHue:fullFuelTankHue saturation:0.88 brightness:0.88 alpha:1.0];

    [progviewFuelTank reset];
}

- (CGFloat)fuelConsumptionPerKm:(CGFloat)speed
{
    // Constant fuel consumption, independent from car acceleration - unreal
    // A formula which take into account gravity and friction should be considered.
    // GPS reading is a more real alternative, even with accuracy issues
    CGFloat fuelConsumption = fuelConsumptionPerKm;
    
    return fuelConsumption;
}

@end

