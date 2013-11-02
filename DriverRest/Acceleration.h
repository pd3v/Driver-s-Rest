// Abstract Factory Class
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, classType)  {
    AccelerationTypeFunction,
    AccelerationTypeGPS,
    AccelerationTypeOther
};

@interface Acceleration : NSObject

+(Acceleration *)initWith:(classType)typeOf;

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration;

@end
