
#import "AMBNBaseEvent.h"

@import UIKit;

@interface AMBNTouch : AMBNBaseEvent

@property unsigned int touchId;
@property CGPoint absoluteLocation;
@property CGPoint relativeLocation;
@property CGFloat force;
@property CGFloat radius;
@property int phase;
@property NSArray *identifiers;


- (instancetype) initWithTouch: (UITouch *) touch touchId: (unsigned int) touchId identifiers: (NSArray *) identifiers;

@end
