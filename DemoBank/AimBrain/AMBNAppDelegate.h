@import UIKit;

#define AMBNDemoAPpUserEmailKey @"AMBNDemoAPpUserEmailKey"
#define AMBNDemoAppUserPinKey @"AMBNDemoAppUserPinKey"
#define AMBNSensitiveSalt @"AMBNSensitiveSalt"


#define AMBNDemoAppUserId @"AMBNDemoAppUserId"
#define AMBNDemoAppUserSession @"AMBNDemoAppUserSession"


@interface AMBNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)setSignInViewAsRootViewControllerWithPin: (NSString *) pin;
-(void)setBankViewAsRootViewController;
-(void)setRegisterViewAsRootViewController;
@end
