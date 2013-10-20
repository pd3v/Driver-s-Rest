
#import <UIKit/UIKit.h>

@class Driver;
@class ARTProgressView;
@class Velocity;

@protocol CarDelegate
- (void)carRanOutOfFuel;
@end

@interface Car : UIView {
    Driver *driver;
    BOOL tripCancelled;
    ARTProgressView *progviewFuelTank;
    Velocity *velocity;
}

@property (nonatomic) CGFloat maxSpeed;
@property (nonatomic) CGFloat maxAcceleration;
@property (nonatomic, readonly) NSUInteger speed;
@property (nonatomic, readonly) NSNumber *distanceTraveled;
@property (nonatomic, readonly) CGFloat fuelTank;

@property (nonatomic, readonly) CGFloat fuelConsumptionPerKm;
@property (nonatomic, readonly) NSUInteger tankCapacityLiters;
@property (nonatomic, readonly) CGFloat fullFuelTankHue;
@property (nonatomic, readonly) CGFloat restingTimeMin;

@property (nonatomic, weak) id <CarDelegate> delegate;

- (void)goTrip;
- (void)stopTrip;
- (void)restartTrip;

@end
