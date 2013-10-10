
#import <UIKit/UIKit.h>

@class Driver;
@class ARTProgressView;

@protocol CarDelegate
- (void)carRanOutOfFuel;
@end

@interface Car : UIView {
    BOOL tripCancelled;
    ARTProgressView *progviewFuelTank;
}

@property (nonatomic) Driver *driver;
@property (nonatomic) NSNumber *fuelTank;
@property (nonatomic) NSNumber *speed;

@property (nonatomic, readonly) CGFloat fuelConsumptionPerKm;
@property (nonatomic, readonly) NSUInteger tankCapacityLiters;
@property (nonatomic, readonly) NSUInteger speedKmH;
@property (nonatomic, readonly) CGFloat fullFuelTankHue;
@property (nonatomic, readonly) CGFloat restingTimeMin;

@property (nonatomic, weak) id <CarDelegate> delegate;

- (void)updateTripTimeFuelTank;
- (void)stopTrip;
- (void)restartTrip;

@end
