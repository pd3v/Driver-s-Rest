
#import "Velocity.h"
#import "VelocityFunction.h"

@implementation Velocity

+(Velocity *) create
{
/*#if defined(USE_VELOCITY_FUNCTION)
    return nil;
#elif defined(USE_VELOCITY_GPS)
    return nil;
#else
    return nil;
#endif*/
    return [[VelocityCurve alloc]init];
}

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration
{
    return nil;
}

@end
