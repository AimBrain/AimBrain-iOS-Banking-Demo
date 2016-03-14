#import "AMBNAppDelegate.h"
#import "AMBNDemoServer.h"
#import "AMBNRegistrationViewController.h"
#import <AimBrainSDK/AimBrainSDK.h>
#import "AMBNEmailVerifiacationViewController.h"

@interface AMBNRegistrationViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation AMBNRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AMBNManager sharedInstance] registerView:self.view withId:@"registration"];
    [[AMBNManager sharedInstance] registerView:self.emailTextField withId:@"email-text-field"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerPressed:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.errorLabel.hidden = true;
        [self.view layoutIfNeeded];
    }];
    [self.activityIndicator startAnimating];
    NSString * email = self.emailTextField.text;
    if(!email){
        email = @"";
    }
    [[AMBNDemoServer sharedInstance] registerEmail:email completion:^( NSURL * loginURL, NSError *error) {
        [self.activityIndicator stopAnimating];
        if (error) {
            NSString * description = error.localizedDescription;
            [UIView animateWithDuration:0.5 animations:^{
                self.errorLabel.text = description;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.errorLabel.hidden = false;
            }];
        }else{
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:self.emailTextField.text forKey:AMBNDemoAPpUserEmailKey];
            [defaults synchronize];
            [self performSegueWithIdentifier:@"verify" sender:loginURL];
        }
        
    }];
    
    
}
- (IBAction)tapped:(id)sender {
    [self.view endEditing:true];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"verify"]){
        AMBNEmailVerifiacationViewController * vc = segue.destinationViewController;
        vc.loginURL = (NSURL *) sender;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
