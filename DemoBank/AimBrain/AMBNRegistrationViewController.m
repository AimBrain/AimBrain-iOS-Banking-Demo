#import "AMBNAppDelegate.h"
#import "AMBNDemoServer.h"
#import "AMBNRegistrationViewController.h"
#import <AimBrainSDK/AimBrainSDK.h>
#import "AMBNEmailVerifiacationViewController.h"
#import "UIViewController+Visibility.h"

@interface AMBNRegistrationViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation AMBNRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AMBNManager sharedInstance] registerView:self.view withId:@"registration"];
    [[AMBNManager sharedInstance] registerView:self.emailTextField withId:@"email-text-field"];
}

- (IBAction)registerPressed:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.errorLabel.hidden = true;
        [self.view layoutIfNeeded];
    }];

    NSString * email = self.emailTextField.text;
    if(!email){
        email = @"";
    }

    [self showNetworkProgress];
    __weak typeof(self) weakSelf = self;
    [[AMBNDemoServer sharedInstance] registerEmail:email completion:^(NSURL *loginURL, NSError *error) {
        [weakSelf hideNetworkProgress];
        if (!weakSelf.isViewVisible) {
            return;
        }
        [weakSelf completeRegisterEmail:loginURL error:error];
    }];
}

- (void)showNetworkProgress {
    [self.activityIndicator startAnimating];
    self.registerButton.enabled = false;
}

- (void)hideNetworkProgress {
    self.registerButton.enabled = true;
    [self.activityIndicator stopAnimating];
}

- (void)completeRegisterEmail:(NSURL *)loginURL error:(NSError *)error {
    if (error) {
        NSString *description = error.localizedDescription;
        [UIView animateWithDuration:0.5 animations:^{
            self.errorLabel.text = description;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.errorLabel.hidden = false;
        }];
    }
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.emailTextField.text forKey:AMBNDemoAPpUserEmailKey];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"verify" sender:loginURL];
    }
}

- (IBAction)tapped:(id)sender {
    [self.view endEditing:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"verify"]){
        AMBNEmailVerifiacationViewController *vc = segue.destinationViewController;
        vc.loginURL = (NSURL *) sender;
    }
}

@end
