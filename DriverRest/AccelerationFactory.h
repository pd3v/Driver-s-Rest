
#import <Foundation/Foundation.h>

@interface AccelerationFactory : NSObject

+(AccelerationFactory *) create;

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration;

@end
