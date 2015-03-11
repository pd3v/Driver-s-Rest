
#import "AccelerationFunction.h"

@implementation AccelerationFunction : Acceleration

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration
{
    // A simple simulation of a driver behavior
    
    maxAcceleration = [NSNumber numberWithFloat:[maxAcceleration floatValue] * 10];

    NSNumber *acceleration = [NSNumber numberWithInt:arc4random() % [maxAcceleration intValue]*10];
    NSUInteger accelerationDeceleration = arc4random() % 2;
    
    NSInteger accDec = [acceleration intValue];
    
    // Accelerate or decelerate
    if (!accelerationDeceleration)
        accDec = accDec * -1;
    
    acceleration = [NSNumber numberWithInt:accDec/10.0];
    
    return acceleration;
}
@end
