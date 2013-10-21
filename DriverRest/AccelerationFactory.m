
#import "AccelerationFactory.h"
#import "AccelerationFunction.h"

@implementation AccelerationFactory

+(AccelerationFactory *) create
{
/*#if defined(USE_VELOCITY_FUNCTION)
    return nil;
#elif defined(USE_VELOCITY_GPS)
    return nil;
#else
    return nil;
#endif*/
    return [[AccelerationFunction alloc]init];
}

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration
{
    return nil;
}

@end
