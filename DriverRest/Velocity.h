
#import <Foundation/Foundation.h>

@interface Velocity : NSObject

+(Velocity *) create;

-(NSNumber *)acceleration:(NSNumber *)maxAcceleration;

@end
