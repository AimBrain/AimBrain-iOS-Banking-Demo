#import "AMBNFaceEnrollmentManager.h"
#import <AimBrainSDK/AMBNEnrollFaceResult.h>

@interface AMBNFaceEnrollmentManager ()
@property BOOL successAlert;
@property NSInteger capturesLeft;
@property UIViewController *viewController;
@property (nonatomic, copy) void (^completion)(BOOL success);
@property NSArray *angleDescriptions;
@end


@implementation AMBNFaceEnrollmentManager

-(id)init{
    self = [super init];
    self.angleDescriptions = @[
            @"To enroll please face the camera directly and press 'camera' button",
            @"Face the camera slightly from the top and press 'camera' button",
            @"Face the camera slightly from the bottom and press 'camera' button",
            @"Face the camera slightly from the left and press 'camera' button",
            @"Face the camera slightly from the right and press 'camera' button"
    ];
    return self;
}

-(void)startVideoEnrollmentForViewController:(UIViewController *)viewController completion:(void (^)(BOOL))completion {
    self.capturesLeft = 5;
    self.completion = completion;
    self.viewController = viewController;
    [self triggerVideoEnrollment];
}

- (void)triggerVideoEnrollment {
    AMBNFaceRecordingViewController *faceRecordingViewController = [[AMBNManager sharedInstance] instantiateFaceRecordingViewControllerWithTopHint:[self.angleDescriptions objectAtIndex:5 - self.capturesLeft] bottomHint:@"Position your face fully within the outline." recordingHint:nil videoLength:2];
    faceRecordingViewController.delegate = self;
    [self.viewController presentViewController:faceRecordingViewController animated:YES completion:^{}];
}

-(void)faceRecordingViewController:(AMBNFaceRecordingViewController *)faceRecordingViewController recordingResult:(NSURL *)video error:(NSError *)error {
    [faceRecordingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (error) {
        [self handleVideoError:error];
    } else {
        [[AMBNManager sharedInstance] enrollFaceVideo:video metadata:nil completionHandler:^(AMBNEnrollFaceResult *result, NSError *error) {
            NSLog(@"%@", result.metadataString);
            if (result.success) {
                [self handleSuccess];
            } else {
                [self handleFailure:error];
            }
        }];
    }
}


-(void)handleVideoError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the video, reason: %@", error.localizedDescription ] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    [alertView show];
}

-(void) handleSuccess {
    self.capturesLeft -= 1;
    if(self.capturesLeft == 0){
        self.completion(true);
    }else{
        [self triggerVideoEnrollment];
    }
}

-(void) handleFailure:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the video, reason: %@", error.localizedDescription ] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self triggerVideoEnrollment];
            break;
        case 1:
            self.completion(false);
            break;
        default:
            break;
    }

}
@end
