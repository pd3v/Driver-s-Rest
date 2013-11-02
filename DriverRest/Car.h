
#import <UIKit/UIKit.h>

@class Driver;
@class ARTProgressView;
@class Acceleration;

@protocol CarDelegate
- (void)carRanOutOfFuel;
@end

@interface Car : UIView {
    Driver *driver;
    ARTProgressView *progviewFuelTank;
    Acceleration *carAcceleration;
    
    BOOL tripCancelled;
}

@property (nonatomic) CGFloat maxSpeedKmH;
@property (nonatomic) CGFloat maxAccelerationMtrSec2;
@property (nonatomic) CGFloat fuelConsumptionPerKm;
@property (nonatomic) NSUInteger tankCapacityLiters;
@property (nonatomic) CGFloat fullFuelTankHue;
@property (nonatomic) NSUInteger driversRestingTimeMin;

@property (nonatomic, readonly) NSUInteger speedKmH;
@property (nonatomic, readonly) NSNumber *distanceTraveledKm;

@property (nonatomic, weak) id <CarDelegate> delegate;

- (void)goTrip;
- (void)stopTrip;
- (void)restartTrip;

@end
