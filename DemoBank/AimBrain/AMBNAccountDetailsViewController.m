#import "AMBNAccountDetailsViewController.h"
#import <AimBrainSDK/AimBrainSDK.h>

@interface AMBNAccountDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (weak, nonatomic) IBOutlet UIButton *viewTransactionButton;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@end

@implementation AMBNAccountDetailsViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [[AMBNManager sharedInstance] registerView:self.view withId:@"account-details"];
    [[AMBNManager sharedInstance] registerView:self.makePaymentButton withId:@"make-payment"];
    [[AMBNManager sharedInstance] registerView:self.viewTransactionButton withId:@"view-transaction"];
    
    self.balanceLabel.text = self.balance;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[AMBNManager sharedInstance] submitBehaviouralDataWithCompletion:^(AMBNResult *result, NSError *error) {
        
    }];
}

@end
