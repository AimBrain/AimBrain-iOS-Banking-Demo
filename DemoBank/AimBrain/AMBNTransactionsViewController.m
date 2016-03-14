#import "AMBNTransactionsViewController.h"
#import "AMBNManager.h"
#import <AimBrainSDK.h>

@implementation AMBNTransactionsViewController

-(void)viewDidLoad{
    [[AMBNManager sharedInstance] registerView:self.view withId:@"transactions-vc"];
}
-(void)viewWillAppear:(BOOL)animated{
    [[AMBNManager sharedInstance] submitBehaviouralDataWithCompletion:^(AMBNResult *result, NSError *error) {
        
    }];
}
@end
