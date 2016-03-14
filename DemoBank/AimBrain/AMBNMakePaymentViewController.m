#import "AMBNMakePaymentViewController.h"
#import <AimBrainSDK/AimBrainSDK.h>
#define AMBNPaymentTo @"922127809434"
#define AMBNPaymentFrom @"122927804349"
#define AMBNPaymentAmount @"143.21"
#define AMBNPaymentReference @"Apartment rental"
@interface AMBNMakePaymentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *referenceLabel;


@end
@implementation AMBNMakePaymentViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.amountLabel.text = AMBNPaymentAmount;
    self.referenceLabel.text = AMBNPaymentReference;
    
    self.referenceTextField.delegate = self;
    [[AMBNManager sharedInstance] registerView:self.view withId:@"make-payment"];
    [[AMBNManager sharedInstance] registerView:self.toTextField withId:@"to"];
    [[AMBNManager sharedInstance] registerView:self.amountTextField withId:@"amount"];
    [[AMBNManager sharedInstance] registerView:self.referenceTextField withId:@"reference"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[AMBNManager sharedInstance] submitBehaviouralDataWithCompletion:^(AMBNResult *result, NSError *error) {
        
    }];
}

- (IBAction)continueButtonPressed:(id)sender {
    if([self valid]){
        [self.navigationController popViewControllerAnimated:true];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid data has been entered" message:@"Please enter exact values from hints above text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

-(BOOL) valid {

    BOOL toValid = [self.toTextField.text isEqualToString:AMBNPaymentTo];
    
    BOOL fromValid = [self.fromTextField.text isEqualToString:AMBNPaymentFrom];
    
    NSString *referenceToValidate = self.referenceTextField.text;
    if(!referenceToValidate){
        referenceToValidate = @"";
    }
    referenceToValidate = [referenceToValidate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL referenceValid = [referenceToValidate caseInsensitiveCompare:AMBNPaymentReference] == NSOrderedSame;
    
    BOOL amountValid = [[self.amountTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."] isEqualToString:AMBNPaymentAmount];
    
    if( toValid && fromValid &&
       amountValid && referenceValid){
        return true;
    }
    return false;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:true];
    return false;
}

- (IBAction)tapped:(id)sender {
    [self.view endEditing:true];
}

@end
