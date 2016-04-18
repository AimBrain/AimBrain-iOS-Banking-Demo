#import "AMBNFaceEnrollmentController.h"

@interface AMBNFaceEnrollmentController ()
@property BOOL successAlert;
@property NSInteger capturesLeft;
@property UIViewController *viewController;
@property (nonatomic, copy) void (^completion)(BOOL success);
@property NSArray *angleDescriptions;
@end


@implementation AMBNFaceEnrollmentController

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

-(void)startMovieEnrollmentForViewController:(UIViewController *)viewController completion:(void (^)(BOOL))completion {
    self.capturesLeft = 5;
    self.completion = completion;
    self.viewController = viewController;
    [self triggerMovieEnrollment];
}

- (void)triggerMovieEnrollment {
    AMBNFaceRecordingViewController *faceRecordingViewController = [[AMBNManager sharedInstance] instantiateFaceRecordingViewControllerWithTopHint:[self.angleDescriptions objectAtIndex:5 - self.capturesLeft] bottomHint:@"Position your face fully within the outline with eyes between the lines." recordingHint:nil movieLength:2];
    faceRecordingViewController.delegate = self;
    [self.viewController presentViewController:faceRecordingViewController animated:YES completion:^{
        
    }];
}

-(void)faceRecordingViewController:(AMBNFaceRecordingViewController *)faceRecordingViewController recordingResult:(NSURL *)video error:(NSError *)error {
    [faceRecordingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (error) {
        [self handleMovieError:error];
    } else {
        [[AMBNManager sharedInstance] enrollFaceMovie:video completion:^(BOOL success, NSError *error) {
            if (success) {
                [self handleSuccess];
            } else {
                [self handleFailure:error];
            }
        }];
    }
}


-(void)handleMovieError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the video, reason: %@", error.localizedDescription ] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    [alertView show];
}

-(void) handleSuccess {
    self.capturesLeft -= 1;
    if(self.capturesLeft == 0){
        self.completion(true);
    }else{
        [self triggerMovieEnrollment];
    }
}

-(void) handleFailure:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the video, reason: %@", error.localizedDescription ] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self triggerMovieEnrollment];
            break;
        case 1:
            self.completion(false);
            break;
        default:
            break;
    }

}
@end
