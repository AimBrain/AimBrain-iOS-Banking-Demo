#import "AMBNAppDelegate.h"
#import <AimBrainSDK/AimBrainSDK.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AMBNSignInViewController.h"

@interface AMBNAppDelegate ()
@property NSTimer *timer;
@end

@implementation AMBNAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    [[AMBNManager sharedInstance] configureWithApplicationId:@"AIMBRAIN_API_KEY" secret:@"AIMBRAIN_API_SECRET"];
    [[AMBNManager sharedInstance] start];


    NSData * sensitiveSalt = [self getSalt];
    [[AMBNManager sharedInstance] setSensitiveSalt:sensitiveSalt];

    NSString * userId = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserId];
    NSString * pin = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserPinKey];
    if(userId && pin){
        [self setSignInViewAsRootViewControllerWithPin:pin];
    }else{
        [self setRegisterViewAsRootViewController];
    }

    return YES;
}
-(void) submitBehaviouralData {
    [[AMBNManager sharedInstance] submitBehaviouralDataWithCompletion:^(AMBNResult *result, NSError *error) {

    }];
}

- (NSData *) getSalt{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData * sensitiveSalt = [defaults dataForKey:AMBNSensitiveSalt];
    if(sensitiveSalt){
        return sensitiveSalt;
    }else{
        sensitiveSalt = [[AMBNManager sharedInstance] generateRandomSensitiveSalt];
        [defaults setObject:sensitiveSalt forKey:AMBNSensitiveSalt];
        [defaults synchronize];
        return sensitiveSalt;
    }


}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:AMBNDemoAppUserSession];
    [defaults synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSString * userId = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserId];
    NSString * pin = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserPinKey];
    if(userId && pin){
        [self setSignInViewAsRootViewControllerWithPin:pin];
    }

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)setRegisterViewAsRootViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"register"];
    [self setRootViewController:vc];

}

-(void)setSignInViewAsRootViewControllerWithPin: (NSString *) pin{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AMBNSignInViewController *vc = [sb instantiateViewControllerWithIdentifier:@"signIn"];
    [vc setPin:pin];
    [self setRootViewController:vc];

}

-(void)setBankViewAsRootViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    [self setRootViewController:vc];
}

-(void)setRootViewController:(UIViewController *)viewController{
    self.window.rootViewController = viewController;
}

@end
