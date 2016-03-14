#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AimBrainSDK/AimBrainSDK.h>


@interface AMBNFaceEnrollmentController : NSObject  <UIAlertViewDelegate>

-(void)startForViewController: (UIViewController *) viewController completion:(void (^)(BOOL success))completion;
@end
