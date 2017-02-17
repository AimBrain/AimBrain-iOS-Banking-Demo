#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AimBrainSDK/AimBrainSDK.h>

@class AMBNSignInViewController;


@interface AMBNVoiceEnrollmentManager : NSObject  <UIAlertViewDelegate, AMBNVoiceRecordingViewControllerDelegate>
-(void)startVoiceEnrollmentForViewController:(AMBNSignInViewController *)viewController completion:(void (^)(BOOL))completion;
@end
