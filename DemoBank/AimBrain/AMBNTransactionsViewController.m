#import "AMBNTransactionsViewController.h"
#import <AimBrainSDK/AimBrainSDK.h>

@implementation AMBNTransactionsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[AMBNManager sharedInstance] registerView:self.view withId:@"transactions-vc"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[AMBNManager sharedInstance] submitBehaviouralDataWithCompletion:^(AMBNResult *result, NSError *error) {
        
    }];
}
@end
