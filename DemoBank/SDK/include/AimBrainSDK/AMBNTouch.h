#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMBNTouch : NSObject

@property unsigned int touchId;
@property CGPoint absoluteLocation;
@property CGPoint relativeLocation;
@property CGFloat force;
@property CGFloat radius;
@property int phase;
@property int timestamp;
@property NSArray *identifiers;


- (instancetype) initWithTouch: (UITouch *) touch touchId: (unsigned int) touchId identifiers: (NSArray *) identifiers;

@end
