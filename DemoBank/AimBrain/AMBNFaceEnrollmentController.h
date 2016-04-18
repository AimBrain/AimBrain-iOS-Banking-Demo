#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AimBrainSDK/AimBrainSDK.h>


@interface AMBNFaceEnrollmentController : NSObject  <UIAlertViewDelegate, AMBNFaceRecordingViewControllerDelegate>
-(void)startMovieEnrollmentForViewController:(UIViewController *)viewController completion:(void (^)(BOOL))completion;
@end
