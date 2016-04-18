#import "AMBNEmailVerifiacationViewController.h"
#import "AMBNDemoServer.h"
#import "AMBNAppDelegate.h"

@interface  AMBNEmailVerifiacationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property NSTimer * retryTimer;
@property BOOL cancelled;
@end

@implementation AMBNEmailVerifiacationViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    //    self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:<#(NSTimeInterval)#> invocation:<#(nonnull NSInvocation *)#> repeats:<#(BOOL)#>]
    [self tryLogin];
    self.cancelled = false;
}


- (void) tryLogin {
    
    [[AMBNDemoServer sharedInstance] login:self.loginURL completion:^( NSString * userId, NSString * pin, NSError *error) {
        if(!self.cancelled){
            if (error) {
                [self.retryTimer invalidate];
                self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(tryLogin) userInfo:nil repeats:false];
                self.useDifferentEmailButton.hidden = false;
                
                NSString * description = error.localizedDescription;
                [UIView animateWithDuration:0.5 animations:^{
                    self.errorLabel.text = description;
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.errorLabel.hidden = false;
                }];
            }else{
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setValue:pin forKey:AMBNDemoAppUserPinKey];
                [defaults setValue:userId forKey:AMBNDemoAppUserId];
                [defaults synchronize];
                AMBNAppDelegate * delegate = [UIApplication sharedApplication].delegate;
                [delegate setSignInViewAsRootViewControllerWithPin:pin];
                
            }
        }
        
    }];
    
}

- (IBAction)useDifferentEmailPressed:(id)sender {
    self.cancelled = true;
    [self.navigationController popViewControllerAnimated:true];
    
    
}

@end
