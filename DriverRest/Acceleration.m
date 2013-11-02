
#import "Acceleration.h"
#import "AccelerationFunction.h"
#import "AccelerationGPS.h"

@implementation Acceleration

+(Acceleration *)initWith:(classType)typeOf
{
    // Could be further decoupled using "objc/runtime.h" library
    if (typeOf == AccelerationTypeFunction)
        return [[AccelerationFunction alloc]init];
    else if (typeOf == AccelerationTypeGPS)
        return [[AccelerationGPS alloc]init];
    
    return nil;
}

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration
{
    return nil;
}

@end
