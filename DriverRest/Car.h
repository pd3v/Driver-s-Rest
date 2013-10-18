
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
    Velocity *speedMoment;
}

@property (nonatomic, readonly) CGFloat fuelTank;

@property (nonatomic, readonly) CGFloat fuelConsumptionPerKm;
@property (nonatomic, readonly) NSUInteger tankCapacityLiters;
@property (nonatomic, readonly) NSUInteger speedKmH;
@property (nonatomic, readonly) CGFloat fullFuelTankHue;
@property (nonatomic, readonly) CGFloat restingTimeMin;

@property (nonatomic, weak) id <CarDelegate> delegate;

- (void)goTrip;
- (void)stopTrip;
- (void)restartTrip;

@end
