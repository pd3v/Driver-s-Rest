
#import "VelocityFunction.h"
#include <stdlib.h>

@implementation VelocityCurve

-(NSNumber *)speed
{
    NSNumber *speedSlice = [NSNumber numberWithInt:arc4random() % 20];
    int acelarationDeacelration = arc4random() % 2;
    
    int spd = [speedSlice intValue];
    
    if (!acelarationDeacelration)
        spd = spd * -1;
    
    speedSlice = [NSNumber numberWithInt:spd];
    
    NSLog(@"acelarationDeacelration:%d speedSlice:%d", acelarationDeacelration, [speedSlice intValue]);
    
    return speedSlice;
}
@end
