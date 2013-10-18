
#import "VelocityFunction.h"
//#include <stdlib.h>

@implementation VelocityCurve

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration
{
    NSNumber *acceleration = [NSNumber numberWithInt:arc4random() % [maxAcceleration intValue]];
    NSUInteger accelerationDeceleration = arc4random() % 2;
    
    NSUInteger accDec = [acceleration intValue];
    
    if (!accelerationDeceleration)
        accDec = accDec * -1;
    
    acceleration = [NSNumber numberWithInt:accDec];
    
    NSLog(@"acceleration=%d", [acceleration intValue]);
    
    return acceleration;
}
@end
