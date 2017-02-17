#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AimBrainSDK/AimBrainSDK.h>


@interface AMBNFaceEnrollmentManager : NSObject  <UIAlertViewDelegate, AMBNFaceRecordingViewControllerDelegate>
-(void)startVideoEnrollmentForViewController:(UIViewController *)viewController completion:(void (^)(BOOL))completion;
@end
