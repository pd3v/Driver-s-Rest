#import "Car.h"
#import "Driver.h"
#import "OWProgressView.h"

#define CONSUMPTION_PER_KM 0.06
#define FUEL_TANK_CAPACITY_LITERS 60
#define SPEED_KM_H 100 // Keeping it on a steady pace. Better move out of the way! :)
#define FULL_FUEL_TANK_HUE 0.36
#define RESTING_TIME_MIN 480
#define TIME_HOLDER_SEC 0.000 // Not a Car property. Declare it as a macro/const.

@implementation Car

@synthesize driver, fuelTank, speed;
@synthesize fuelConsumptionPerKm, tankCapacityLiters, speedKmH, fullFuelTankHue, restingTimeMin;
@synthesize viewFuelTank;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        driver = [[Driver alloc]init];
        
        fuelConsumptionPerKm = CONSUMPTION_PER_KM;
        tankCapacityLiters = FUEL_TANK_CAPACITY_LITERS;
        speedKmH = SPEED_KM_H;
        fullFuelTankHue = FULL_FUEL_TANK_HUE;
        restingTimeMin = RESTING_TIME_MIN;
        
        driver.drivingTime = [NSNumber numberWithInt:0];
        driver.restingTime = [NSNumber numberWithInt:restingTimeMin];
        fuelTank = [NSNumber numberWithFloat:1.0];

        viewFuelTank = [[OWProgressView alloc]initWithFrame:CGRectMake(20, 395, 280, 40)];
        viewFuelTank.progressTintColor = [NSNumber numberWithFloat:fullFuelTankHue];
        viewFuelTank.description = @"Fuel";
        viewFuelTank.maxLabelValue = [NSNumber numberWithFloat:tankCapacityLiters];

        self.userInteractionEnabled = NO;
        [self addSubview:(UIView *)viewFuelTank];
    }
    return self;
}

- (void)setFuelTank:(NSNumber *)aFuelTank
{
    fuelTank = aFuelTank;

    if ([aFuelTank floatValue] == 0)
        dispatch_sync(dispatch_get_main_queue(), ^{ [self.delegate carRanOutOfFuel]; });

    dispatch_sync(dispatch_get_main_queue(), ^{
        CGFloat hue;
        UIColor *cor = [UIColor colorWithHue:[viewFuelTank.progressTintColor floatValue] saturation:0.88 brightness:0.88 alpha:1];
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];

        hue -= fullFuelTankHue / ( (tankCapacityLiters * 60) / (speedKmH * fuelConsumptionPerKm) );
        viewFuelTank.progressTintColor = [NSNumber numberWithFloat:hue];
    });
    
}

- (void)updateTripTimeFuelTank
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSUInteger tripTime = [driver.drivingTime intValue];
        CGFloat fuelTankLevel = [fuelTank floatValue];
        
        CGFloat consumedFuel = 0;
        NSUInteger distanceTravelled = 0;
        
        while (fuelTankLevel >= 0.0 && fuelTankLevel <= 1.0 && !tripCancelled) {
            
            [NSThread sleepForTimeInterval:TIME_HOLDER_SEC];
            
            consumedFuel = tripTime * speedKmH * fuelConsumptionPerKm / 60;
            distanceTravelled = tripTime * speedKmH / 60; // Variable not used. Just info.
            fuelTankLevel = 1.0 - (consumedFuel / tankCapacityLiters);
            
            tripTime += 1; // trip time in minutes
            
            self.fuelTank = [NSNumber numberWithFloat:fuelTankLevel];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                driver.drivingTime = [NSNumber numberWithInt:tripTime];
                viewFuelTank.progressValue = fuelTank;
            });
           
            if (tripTime % [driver.restingTime intValue] == 0 && tripTime != 0)
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
    fuelTank = [NSNumber numberWithFloat:1.0];
    driver.drivingTime = [NSNumber numberWithInt:0];
    
    viewFuelTank.progressValue = [NSNumber numberWithFloat:1.0];
    viewFuelTank.maxLabelValue = [NSNumber numberWithFloat:tankCapacityLiters];
    viewFuelTank.progressTintColor = [NSNumber numberWithFloat:fullFuelTankHue];
    
    [viewFuelTank reset];
}

@end

