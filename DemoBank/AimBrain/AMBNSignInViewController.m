#import "AMBNSignInViewController.h"
#import "AMBNAppDelegate.h"
#import <AimBrainSDK/AMBNSessionCreateResult.h>
#import <AimBrainSDK/AMBNVoiceTextResult.h>
#import <AimBrainSDK/AMBNVoiceRecordingViewController.h>
#import <AimBrainSDK/AMBNAuthenticateResult.h>
#import "AMBNFaceEnrollmentManager.h"
#import "AMBNVoiceEnrollmentManager.h"
#import "UIViewController+Visibility.h"

@interface AMBNSignInViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSTimer *wrongPinTimer;
@property (nonatomic, strong) AMBNFaceEnrollmentManager *faceEnrollmentController;
@property (nonatomic, strong) AMBNVoiceEnrollmentManager *voiceEnrollmentController;

@end

@implementation AMBNSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAPpUserEmailKey];
    self.emailLabel.text = email;
    self.pinLabel.text = self.pin;
    [[AMBNManager sharedInstance] registerView:self.view withId:@"sign-in-vc"];
    [[AMBNManager sharedInstance] registerView:self.pinTextField withId:@"pin-text-field"];
    [[AMBNManager sharedInstance] registerView:self.oneButton withId:@"1"];
    [[AMBNManager sharedInstance] registerView:self.twoButton withId:@"2"];
    [[AMBNManager sharedInstance] registerView:self.threeButton withId:@"3"];
    [[AMBNManager sharedInstance] registerView:self.fourButton withId:@"4"];
    [[AMBNManager sharedInstance] registerView:self.fiveButton withId:@"5"];
    [[AMBNManager sharedInstance] registerView:self.sixButton withId:@"6"];
    [[AMBNManager sharedInstance] registerView:self.sevenButton withId:@"7"];
    [[AMBNManager sharedInstance] registerView:self.eightButton withId:@"8"];
    [[AMBNManager sharedInstance] registerView:self.nineButton withId:@"9"];
    [[AMBNManager sharedInstance] registerView:self.zeroButton withId:@"0"];
    [[AMBNManager sharedInstance] registerView:self.okButton withId:@"OK"];
    [[AMBNManager sharedInstance] registerView:self.backSpaceButton withId:@"backspace"];
    
   [[AMBNManager sharedInstance] addSensitiveViews:@[self.view]];
}

- (IBAction)signInPressed:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.errorLabel.text = @"";
        [self.view layoutIfNeeded];
    }];
    self.errorLabel.hidden = true;

    if ([self.pinTextField.text isEqual:self.pin]) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserId];
        [self showProcessingProgress];
        __weak typeof(self) weakSelf = self;
        [[AMBNManager sharedInstance] createSessionWithUserId:userId completionHandler:^(AMBNSessionCreateResult *result, NSError *error) {
            [weakSelf hideProcessingProgress];
            if (!weakSelf.isViewVisible) {
                return;
            }
            [weakSelf completeCreatePinSessionWithResult:result error:error];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.errorLabel.text = @"Wrong PIN";
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.errorLabel.hidden = false;
        }];

        self.pinTextField.text = @"";
    }
}

- (void)completeCreatePinSessionWithResult:(AMBNSessionCreateResult *)result error:(NSError *)error {
    AMBNAppDelegate * delegate = [UIApplication sharedApplication].delegate;
    if (result) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result.session forKey:AMBNDemoAppUserSession];
        [defaults synchronize];
        [delegate setBankViewAsRootViewController];
    } else {
        NSString *description = error.localizedDescription;
        [UIView animateWithDuration:0.5 animations:^{
            self.errorLabel.text = description;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.errorLabel.hidden = false;
        }];
    }
}

- (IBAction)cameraMicrophoneButtonTapped:(id)sender {
    [[[UIActionSheet alloc] initWithTitle:@"Please choose:"
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Facial authentication", @"Voice authentication", nil] showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self authenticateWithFace];
    }
    if (buttonIndex == 1) {
        [self authenticateWithVoice];
    }
}

- (void)authenticateWithFace {
    [UIView animateWithDuration:0.5 animations:^{
        self.errorLabel.text = @"";
        [self.view layoutIfNeeded];
    }];
    NSString * userId = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserId];
    self.errorLabel.hidden = true;
    [self showProcessingProgress];
    __weak typeof(self) weakSelf = self;
    [[AMBNManager sharedInstance] createSessionWithUserId:userId completionHandler:^(AMBNSessionCreateResult *result, NSError *error) {
        [weakSelf hideProcessingProgress];
        if (!weakSelf.isViewVisible) {
            return;
        }
        [weakSelf completeCreateFaceSessionWithResult:result error:error];
    }];
}

- (void)completeCreateFaceSessionWithResult:(AMBNSessionCreateResult *)result error:(NSError *)error {
    if (result) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result.session forKey:AMBNDemoAppUserSession];
        [defaults synchronize];
        switch ([result.face integerValue]) {
            case 0: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enroll before using Facial authentication" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                alertView.tag = 1;
                [alertView show];
                break;
            }
            case 1: {
                [self startFaceAuthenticationWithVideo];
                break;
            }
            case 2: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Generating template." message:@"Please try again in a few seconds" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                break;
            }
            default: {
                break;
            }
        };
    }
    else {
        NSString *description = error.localizedDescription;
        [UIView animateWithDuration:0.5 animations:^{
            self.errorLabel.text = description;
            [self.view layoutIfNeeded];
        }                completion:^(BOOL finished) {
            self.errorLabel.hidden = false;
        }];

    }
}

- (void)startFaceAuthenticationWithVideo {
    [self.activityIndicator startAnimating];
    AMBNFaceRecordingViewController *recordingViewController = [[AMBNManager sharedInstance] instantiateFaceRecordingViewControllerWithTopHint:@"To authenticate please face the camera directly, press 'camera' button and blink"
                                                                                                                                        bottomHint:@"Position your face fully within the outline with eyes between the lines."
                                                                                                                                     recordingHint:@"Please BLINK now..."
                                                                                                                                       videoLength:2];
    recordingViewController.delegate = self;
    [self presentViewController:recordingViewController animated:YES completion:nil];
}

- (void)authenticateWithVoice {
    [UIView animateWithDuration:0.5 animations:^{
        self.errorLabel.text = @"";
        [self.view layoutIfNeeded];
    }];
    NSString * userId = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserId];
    self.errorLabel.hidden = true;
    [self showProcessingProgress];
    __weak typeof(self) weakSelf = self;
    [[AMBNManager sharedInstance] createSessionWithUserId:userId completionHandler:^(AMBNSessionCreateResult *result, NSError *error) {
        [weakSelf hideProcessingProgress];
        if (!weakSelf.isViewVisible) {
            return;
        }
        [weakSelf completeCreateVoiceSessionWithResult:result error:error];
    }];
}

- (void)completeCreateVoiceSessionWithResult:(AMBNSessionCreateResult *)result error:(NSError *)error {
    if (result) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result.session forKey:AMBNDemoAppUserSession];
        [defaults synchronize];
        switch ([result.voice integerValue]) {
            case 0: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enroll before using voice authentication" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                alertView.tag = 3;
                [alertView show];
                break;
            }
            case 1: {
                [self startVoiceAuthenticationWithAudio];
                break;
            }
            case 2: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Generating template." message:@"Please try again in a few seconds" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                break;
            }
            default: {
                break;
            }

        };
    }
    else {
        NSString *description = error.localizedDescription;
        [UIView animateWithDuration:0.5 animations:^{
            self.errorLabel.text = description;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.errorLabel.hidden = false;
        }];

    }
}

- (void)startVoiceAuthenticationWithAudio {
    [self showProcessingProgress];
    __weak typeof(self) weakSelf = self;
    [[AMBNManager sharedInstance] getVoiceTokenWithType:AMBNVoiceTokenTypeAuth completionHandler:^(AMBNVoiceTextResult *result, NSError *error) {
        [weakSelf hideProcessingProgress];
        if (!weakSelf.isViewVisible) {
            return;
        }
        [weakSelf openVoiceRecordingControllerWithTextToRead:result.tokenText];
    }];
}

- (void)openVoiceRecordingControllerWithTextToRead:(NSString*)text {
    AMBNVoiceRecordingViewController *voiceRecordingViewController = [[AMBNManager sharedInstance] instantiateVoiceRecordingViewControllerWithTopHint:@"To authenticate please press 'microphone' button and read text below" bottomHint:@"You will have 5 seconds" recordingHint:text audioLength:5];
    voiceRecordingViewController.delegate = self;
    [self presentViewController:voiceRecordingViewController animated:YES completion:^{}];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        switch (buttonIndex) {
            case 0: {
                break;
            }
            case 1: {
                self.faceEnrollmentController = [AMBNFaceEnrollmentManager new];
                [self.faceEnrollmentController startVideoEnrollmentForViewController:self completion:^(BOOL success) {
                    if (success) {
                        [[[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Enrollment finished successfully"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil] show];
                    }
                }];
                break;
            }
            default:
                break;
        }
    }
    else if (alertView.tag == 2) {
        switch (buttonIndex) {
            case 0: {
                [self startFaceAuthenticationWithVideo];
                break;
            }
            case 1: {

                break;
            }
            default:
                break;
        }
    }
    else if (alertView.tag == 3) {
        switch (buttonIndex) {
            case 0: {
                break;
            }
            case 1: {
                self.voiceEnrollmentController = [AMBNVoiceEnrollmentManager new];
                [self.voiceEnrollmentController startVoiceEnrollmentForViewController:self completion:^(BOOL success) {
                    if (success) {
                        [[[UIAlertView alloc] initWithTitle:@"" message:@"Enrollment finished successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                    }
                }];

                break;
            }
            default:
                break;
        }
    }
    else if (alertView.tag == 4) {
        switch (buttonIndex) {
            case 0: {
                [self startVoiceAuthenticationWithAudio];
                break;
            }
            case 1: {
                break;
            }
            default:
                break;
        }
    }
}

- (void)faceRecordingViewController:(AMBNFaceRecordingViewController *)faceRecordingViewController recordingResult:(NSURL *)video error:(NSError *)error {
    [faceRecordingViewController dismissViewControllerAnimated:YES completion:nil];

    if(error){
        [[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else {
        [self showProcessingProgress];
        __weak typeof(self) weakSelf = self;
        [[AMBNManager sharedInstance] authenticateFaceVideo:video completionHandler:^(AMBNAuthenticateResult *result, NSError *authError) {
            [weakSelf hideProcessingProgress];
            if (!weakSelf.isViewVisible) {
                return;
            }
            if (authError) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the video, reason: %@", authError.localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                alertView.tag = 2;
                [alertView show];
            }
            else {
                if ([result.score floatValue] >= 0.5 && [result.liveliness floatValue] >= 0.5) {
                    AMBNAppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    [delegate setBankViewAsRootViewController];
                } else {
                    NSString *message = @"";
                    if ([result.score floatValue] >= 0.5) {
                        message = [NSString stringWithFormat:@"Your face matched to %.0f%%, but it failed the liveliness test", [result.score floatValue] * 100];
                    }
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access denied" message:message delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
                    alertView.tag = 2;
                    [alertView show];
                }
            }
        }];
    }
}

- (void)voiceRecordingViewController:(AMBNVoiceRecordingViewController *)voiceRecordingViewController recordingResult:(NSURL *)audio error:(NSError *)error {
    [voiceRecordingViewController dismissViewControllerAnimated:YES completion:^{}];
    if (error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else {
        [self showProcessingProgress];
        __weak typeof(self) weakSelf = self;
        [[AMBNManager sharedInstance] authenticateVoice:audio completionHandler:^(AMBNAuthenticateResult *result, NSError *authError) {
            [weakSelf hideProcessingProgress];
            if (!weakSelf.isViewVisible) {
                return;
            }
            if (authError){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-record the voice, reason: %@", authError.localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                alertView.tag = 4;
                [alertView show];
                
            }
            else{
                if([result.score floatValue] >= 0.5 && [result.liveliness floatValue] >= 0.5){
                    AMBNAppDelegate * delegate = [UIApplication sharedApplication].delegate;
                    [delegate setBankViewAsRootViewController];
                }
                else{
                    NSString * message = @"";
                    if ([result.score floatValue] >= 0.5) {
                        message = [NSString stringWithFormat:@"Your voice matched to %.0f%%, but it failed the liveliness test", [result.score floatValue] * 100 ];
                    }
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access denied" message:message delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: @"Cancel", nil];
                    alertView.tag = 4;
                    [alertView show];
                }
            }
        }];
    }
}

- (IBAction)backspaceButtonPressed:(id)sender {
    NSString *currentPin = self.pinTextField.text;
    if(currentPin.length > 0){
        [self.pinTextField setText:@""];
    }
}

- (IBAction)tapped:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)numberButtonPressed:(id)sender {
    UIButton * button = sender;
    NSString * oldText = self.pinTextField.text;
    if(!oldText){
        oldText = @"";
    }
    [self.pinTextField setText:[oldText stringByAppendingString:[button titleForState:UIControlStateNormal]]];
    
}

- (void)hideProcessingProgress {
    [self.activityIndicator stopAnimating];
    self.okButton.enabled = true;
    self.authButton.enabled = true;
}

- (void)showProcessingProgress {
    self.okButton.enabled = false;
    self.authButton.enabled = false;
    [self.activityIndicator startAnimating];
}

@end
