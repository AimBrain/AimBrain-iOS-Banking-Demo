#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AMBNTextEvent.h"

@protocol AMBNTextInputCollectorDelegate <NSObject>

@required
-(void) textInputCollector: (id) textInputCollector didCollectTextInput: (AMBNTextEvent *) textEvent;
- (BOOL) textInputCollector: (id) textInputCollector shouldIngoreEventForView: (UIView *) view;
- (BOOL) textInputCollector: (id) textInputCollector shouldTreatAsSenitive: (UIView *) view;
@end