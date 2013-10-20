
#import "VelocityFunction.h"
//#include <stdlib.h>

@implementation VelocityCurve

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration
{
    maxAcceleration = [NSNumber numberWithFloat:[maxAcceleration floatValue] * 10];

    NSNumber *acceleration = [NSNumber numberWithInt:arc4random() % [maxAcceleration intValue]*10];
    NSUInteger accelerationDeceleration = arc4random() % 2;
    
    NSInteger accDec = [acceleration intValue];
    
    // Accelerate or decelerate
    if (!accelerationDeceleration)
        accDec = accDec * -1;
    
    acceleration = [NSNumber numberWithInt:accDec/10];
    
    // NSLog(@"acceleration=%d", [acceleration intValue]);
    
    return acceleration;
}
@end
