#import "AMBNFaceEnrollmentController.h"

@interface AMBNFaceEnrollmentController ()
@property BOOL successAlert;
@property NSInteger picturesLeft;
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

-(void)startForViewController: (UIViewController *) viewController completion:(void (^)(BOOL success))completion {
    self.viewController = viewController;
    self.completion = completion;
    self.picturesLeft = 5;
    [self triggerEnrollment];
}

-(void) triggerEnrollment{
    [[AMBNManager sharedInstance] openFaceImagesCaptureWithTopHint:[self.angleDescriptions objectAtIndex:5 - self.picturesLeft] bottomHint:@"Position your face fully within the outline with eyes between the lines." batchSize:3 delay:0.3 fromViewController:self.viewController completion:^(BOOL success, NSArray *images) {
     [[AMBNManager sharedInstance] enrollFaceImages:images completion:^(BOOL success, NSNumber *imagesCount, NSError *error) {

         if(success){
             [self handleSuccess];
         }else{
             [self handleFailure:error];
         }

     }];
    }];
}

-(void) handleSuccess {
    self.picturesLeft -= 1;
    if(self.picturesLeft == 0){
        self.completion(true);
    }else{
        [self triggerEnrollment];
    }
}

-(void) handleFailure:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the picture, reason: %@", error.localizedDescription ] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self triggerEnrollment];
            break;
        case 1:
            self.completion(false);
            break;
        default:
            break;
    }

}
@end
