#import "AMBNBaseEvent.h"
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>

@interface AMBNAcceleration : AMBNBaseEvent

@property CGFloat x;
@property CGFloat y;
@property CGFloat z;

+ (instancetype) accelerationWithAccelerationData:(CMAccelerometerData *) data;

@end
