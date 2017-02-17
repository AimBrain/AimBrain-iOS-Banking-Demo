#import "AMBNBankMenuViewController.h"
#import "AMBNAppDelegate.h"
#import <AimBrainSDK/AimBrainSDK.h>
#import "AMBNAccountDetailsViewController.h"

@interface AMBNBankMenuViewController ()

@end

@implementation AMBNBankMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AMBNManager sharedInstance] registerView:self.view withId:@"bank-menu"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[AMBNManager sharedInstance] submitBehaviouralDataWithCompletionHandler:^(AMBNBehaviouralResult *result, NSError *error) {}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            break;
        case 2:{
            NSString *email = [NSString stringWithFormat:@"mailto:%@?subject=%@",@"team@aimbrain.com" ,@"Banking Authentication App iOS Feedback"];
            email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
            break;
        }
        case 3:
            switch (indexPath.row){
                case 0:{
                    AMBNAppDelegate * delegate = [[UIApplication sharedApplication] delegate];
                    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
                    
                    [defaults removeObjectForKey:AMBNDemoAppUserSession];
                    [defaults synchronize];
                    NSString * userId = [defaults stringForKey:AMBNDemoAppUserId];
                    NSString * pin = [defaults stringForKey:AMBNDemoAppUserPinKey];
                    if(userId && pin){
                        [delegate setSignInViewAsRootViewControllerWithPin:pin];
                    }else{
                        [delegate setRegisterViewAsRootViewController];
                    }
                    break;
                }
                case 1: {
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    [defaults removeObjectForKey:AMBNDemoAPpUserEmailKey];
                    [defaults removeObjectForKey:AMBNDemoAppUserSession];
                    [defaults removeObjectForKey:AMBNDemoAppUserPinKey];
                    [defaults removeObjectForKey:AMBNDemoAppUserId];
                    [defaults removeObjectForKey:AMBNSensitiveSalt];
                    [defaults synchronize];
                    AMBNAppDelegate * delegate = [UIApplication sharedApplication].delegate;
                    [delegate setRegisterViewAsRootViewController];
                    break;

                }
            }
        
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"firstAccount"]) {
        AMBNAccountDetailsViewController * vc = segue.destinationViewController;
        vc.balance = @"£2034.42";
    }else if ([segue.identifier  isEqual: @"secondAccount"]){
        AMBNAccountDetailsViewController * vc = segue.destinationViewController;
        vc.balance = @"£1230.20";
    }
}
@end
