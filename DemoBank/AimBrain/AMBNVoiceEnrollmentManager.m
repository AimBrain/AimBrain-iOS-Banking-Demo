#import <AimBrainSDK/AMBNVoiceTextResult.h>
#import <AimBrainSDK/AMBNVoiceRecordingViewController.h>
#import <AimBrainSDK/AMBNEnrollVoiceResult.h>
#import <AimBrainSDK/AMBNManager.h>
#import "AMBNVoiceEnrollmentManager.h"
#import "AMBNSignInViewController.h"
#import "UIViewController+Visibility.h"

@interface AMBNVoiceEnrollmentManager ()
@property NSUInteger capturesLeft;
@property AMBNSignInViewController *viewController;
@property (nonatomic, copy) void (^completion)(BOOL success);
@property NSArray *captureDescriptions;
@property NSArray *tokenTypes;
@property NSString *currentTokenText;
@property AMBNVoiceTokenType currentTokenType;
@end


@implementation AMBNVoiceEnrollmentManager

- (id)init {
    self = [super init];
    self.captureDescriptions = @[
            @"To enroll please press 'microphone' button read text below",
            @"Please press 'microphone' button read the text below 2nd time",
            @"Please press 'microphone' button read the text below 3rd time",
            @"Please press 'microphone' button read the text below 4th time",
            @"Please press 'microphone' button read the text below the last time"
    ];
    self.tokenTypes = @[
            @(AMBNVoiceTokenTypeEnroll1),
            @(AMBNVoiceTokenTypeEnroll2),
            @(AMBNVoiceTokenTypeEnroll3),
            @(AMBNVoiceTokenTypeEnroll4),
            @(AMBNVoiceTokenTypeEnroll5)
    ];
    return self;
}

- (void)startVoiceEnrollmentForViewController:(AMBNSignInViewController *)viewController completion:(void (^)(BOOL))completion {
    self.capturesLeft = 5;
    self.completion = completion;
    self.viewController = viewController;
    [self triggerVoiceEnrollment];
}

- (void)triggerVoiceEnrollment {
    self.currentTokenType = (AMBNVoiceTokenType) [self.tokenTypes[5 - self.capturesLeft] intValue];
    [self.viewController showProcessingProgress];
    [[AMBNManager sharedInstance] getVoiceTokenWithType:self.currentTokenType completionHandler:^(AMBNVoiceTextResult *result, NSError *error) {
        [self.viewController hideProcessingProgress];
        if (!self.viewController.isViewVisible) {
            return;
        }
        if (!error) {
            self.currentTokenText = result.tokenText;
            NSString *hint = self.captureDescriptions[5 - self.capturesLeft];
            NSString *bottomHint = @"You will have 5 seconds";
            NSString *text = self.currentTokenText;
            AMBNVoiceRecordingViewController *vc = [[AMBNManager sharedInstance] instantiateVoiceRecordingViewControllerWithTopHint:hint bottomHint:bottomHint recordingHint:text audioLength:5];
            vc.delegate = self;
            [self.viewController presentViewController:vc animated:YES completion:^{}];
        }
        else {
            [self handleFailure:error];
        }
    }];
}

- (void)voiceRecordingViewController:(AMBNVoiceRecordingViewController *)voiceRecordingViewController recordingResult:(NSURL *)audio error:(NSError *)error {
    [voiceRecordingViewController dismissViewControllerAnimated:YES completion:^{}];
    if (error) {
        [self handleAudioError:error];
    }
    else {
        [self.viewController showProcessingProgress];
        [[AMBNManager sharedInstance] enrollVoice:audio completionHandler:^(AMBNEnrollVoiceResult *result, NSError *enrollError) {
            [self.viewController hideProcessingProgress];
            if (!self.viewController.isViewVisible) {
                return;
            }
            if (result.success) {
                [self handleSuccess];
            }
            else {
                [self handleFailure:enrollError];
            }
        }];
    }
}

- (void)voiceRecordingViewControllerClosedByUser {
    self.completion(false);
}

- (void)handleAudioError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the audio, reason: %@", error.localizedDescription] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    [alertView show];
}

- (void)handleSuccess {
    self.capturesLeft -= 1;
    if(self.capturesLeft == 0) {
        self.completion(true);
    }
    else {
        [self triggerVoiceEnrollment];
    }
}

- (void)handleFailure:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the audio, reason: %@", error.localizedDescription] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self triggerVoiceEnrollment];
            break;
        case 1:
            self.completion(false);
            break;
        default:
            break;
    }
}

@end
