#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AMBNCameraOverlayDelegate.h"

@interface AMBNFaceCaptureManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMBNCameraOverlayDelegate>


- (void) openCaptureViewFromViewController:(UIViewController *) viewController topHint:(NSString*)topHint bottomHint: (NSString *) bottomHint batchSize: (NSInteger) batchSize delay: (NSTimeInterval) delay completion:(void (^)(BOOL success, NSArray * images))completion;

@end
