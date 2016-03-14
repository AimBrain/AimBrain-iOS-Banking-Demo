#import "AMBNSignInViewController.h"
#import "AMBNAppDelegate.h"
#import <AimBrainSDK/AimBrainSDK.h>
#import "AMBNFaceEnrollmentController.h"


@interface AMBNSignInViewController ()
@property NSTimer *wrongPinTimer;
@property AMBNFaceEnrollmentController *faceEnrollmentController;
@property UIAlertView *enrollmentConfirmationAlert;
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

-(void)viewWillAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signInPressed:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.errorLabel.text = @"";
        [self.view layoutIfNeeded];
    }];
    self.errorLabel.hidden = true;
    
    
    if([self.pinTextField.text  isEqual: self.pin]){
        AMBNAppDelegate * delegate = [UIApplication sharedApplication].delegate;
        NSString * userId = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserId];
        [self.activityIndicator startAnimating];
        [[AMBNManager sharedInstance] createSessionWithUserId:userId completion:^(NSString *session, NSNumber * face, NSNumber *behavioural, NSError *error) {
            [self.activityIndicator stopAnimating];
            if(session){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:session forKey:AMBNDemoAppUserSession];
                [defaults synchronize];
                [delegate setBankViewAsRootViewController];
            }else{
                
                NSString * description = error.localizedDescription;
                [UIView animateWithDuration:0.5 animations:^{
                    self.errorLabel.text = description;
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.errorLabel.hidden = false;
                }];
            }
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.errorLabel.text = @"Wrong PIN";
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.errorLabel.hidden = false;
        }];
        
        
        self.pinTextField.text = @"";
    }
}

- (IBAction)cameraButtonTapped:(id)sender {
    UIButton * button = (UIButton *)sender;
    [button setEnabled:false];
    [UIView animateWithDuration:0.5 animations:^{
        self.errorLabel.text = @"";
        [self.view layoutIfNeeded];
    }];
    self.errorLabel.hidden = true;
    NSString * userId = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserId];
    [self.activityIndicator startAnimating];
    [[AMBNManager sharedInstance] createSessionWithUserId:userId completion:^(NSString *session, NSNumber * face, NSNumber *behavioural, NSError *error) {
        [self.activityIndicator stopAnimating];
        [button setEnabled:true];
        if(session){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:session forKey:AMBNDemoAppUserSession];
            [defaults synchronize];
        switch ([face integerValue]) {
            case 0:{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enroll before using Facial authentication" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                self.enrollmentConfirmationAlert = alertView;
                [alertView show];
                break;
            }
            case 1:
            {
                [self startFaceAuthentication];
                break;
            }
            case 2:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Templates are being prepared" message:@"Please try again shortly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                break;
            }
            default:
            {
                break;
            }
                
        };
        }else{
            NSString * description = error.localizedDescription;
            [UIView animateWithDuration:0.5 animations:^{
                self.errorLabel.text = description;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.errorLabel.hidden = false;
            }];

        }
        
        
    }];

}
-(void) startFaceAuthentication{
    [self.activityIndicator startAnimating];
    [[AMBNManager sharedInstance] openFaceImagesCaptureWithTopHint:@"To authenticate please face the camera directly and press 'camera' button" bottomHint:@"Position your face fully within the outline with eyes between the lines." batchSize:3 delay:0.3 fromViewController:self completion:^(BOOL success, NSArray *images) {
            [[AMBNManager sharedInstance] authenticateFaceImages:images completion:^(NSNumber *score, NSNumber *liveliness, NSError *error) {

                [self.activityIndicator stopAnimating];
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please re-take the picture, reason: %@", error.localizedDescription ] delegate:self cancelButtonTitle:@"OK"otherButtonTitles: @"Cancel", nil];
                    [alertView show];
                    
                }else{
                    if([score floatValue] >= 0.5 && [liveliness floatValue] >= 0.5){
                        AMBNAppDelegate * delegate = [UIApplication sharedApplication].delegate;
                        [delegate setBankViewAsRootViewController];
                        
                    }else{
                        NSString * message = @"";
                        if([liveliness floatValue] < 0.5){
                            message = [NSString stringWithFormat:@"Your face matched to %.0f%% but we believe it was a static image", [score floatValue] * 100 ];
                        }
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access denied" message:message delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: @"Cancel", nil];
                        [alertView show];
                    }
                }

 
            }];
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == self.enrollmentConfirmationAlert){
        switch (buttonIndex) {
            case 0:
            {
                break;
            }
            case 1:
            {
                [self.activityIndicator startAnimating];
                self.faceEnrollmentController = [[AMBNFaceEnrollmentController alloc] init];
                [self.faceEnrollmentController startForViewController:self completion:^(BOOL success) {
                    if(success){
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Enrollment finished successfully" delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
                        [alertView show];
                    }
                    [self.activityIndicator stopAnimating];
                }];

                break;
            }
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
            {
                [self startFaceAuthentication];
                break;
            }
            case 1:
            {
                
                break;
            }
            default:
                break;
        }
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

@end
