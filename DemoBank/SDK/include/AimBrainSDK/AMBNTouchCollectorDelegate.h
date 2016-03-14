#import <Foundation/Foundation.h>
#import "AMBNTouch.h"

@protocol AMBNTouchCollectorDelegate <NSObject>

@required
-(void) touchCollector: (id) touchCollector didCollectedTouch: (AMBNTouch *) touch;

-(BOOL) touchCollector: (id) touchCollector shouldIgnoreTouchForView: (UIView *) view;

-(BOOL) touchCollector: (id) touchCollector shouldTreatAsSenitive: (UIView *) view;

@end