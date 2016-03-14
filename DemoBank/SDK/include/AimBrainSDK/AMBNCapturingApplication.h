#import <UIKit/UIKit.h>
#import "AMBNCapturingApplicationDelegate.h"

/*!
 @discussion UIApplication subclass used to capture touch events.
 */
@interface AMBNCapturingApplication : UIApplication


@property (nonatomic, weak) id <AMBNCapturingApplicationDelegate> capturingDelegate;

@end
