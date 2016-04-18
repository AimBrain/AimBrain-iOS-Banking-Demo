#import "AMBNDebugViewController.h"
#import <AimBrainSDK/AimBrainSDK.h>
#import "AMBNAppDelegate.h"

#define AMBNResultDemoStatusEnrollingDone 2
#define AMBNResultDemoStatusAuthenticatingDone 3

@interface AMBNDebugViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *userLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *sessionIdValueLabel;

@property NSString *enrolingDonePopupSession;
@property NSString *authenticatingDonePopupSession;

@property NSDate * lastUpdated;


@end
@implementation AMBNDebugViewController
{
    NSTimer *hideTimer;
    NSTimer *lastUpdateTimer;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(behaviouralDataSubmitted:) name:AMBNManagerBehaviouralDataSubmittedNotification object:nil];
    [self.view layoutIfNeeded];
    lastUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLastUpdate) userInfo:nil repeats:true];
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAPpUserEmailKey];
    self.userLabelValue.text = email;
    self.userIdLabelValue.text = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserId];
    self.sessionIdValueLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:AMBNDemoAppUserSession];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)updateLastUpdate{
    if(self.lastUpdated){
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastUpdated];
        self.lastUpdatedValueLabel.text = [NSString stringWithFormat:@"%.0f seconds ago",round(interval)];
    }else{
        self.lastUpdatedValueLabel.text = [NSString stringWithFormat:@"-"];
    }
}


-(void)behaviouralDataSubmitted: (NSNotification *) notification{
    AMBNResult * result = notification.object;
    self.lastUpdated = [NSDate date];
    self.scoreLabelValue.text = [NSString stringWithFormat:@"%.0f%%",round([result.score floatValue] * 100)];

    switch (result.status) {

        case AMBNResultStatusEnrolling: {
            self.statusLabelValue.text = @"Enrolling";
            self.scoreLabel.text = @"Progress:";
            [self.debugView setBackgroundColor:[self unknownColor]];
            break;
        }
        case AMBNResultDemoStatusEnrollingDone: {
            self.statusLabelValue.text = @"Enrolling (end of session)";
            self.scoreLabel.text = @"Progress:";
            [self.debugView setBackgroundColor:[UIColor colorWithRed:203.0/255 green:199.0/255 blue:35.0/255 alpha:1]];
            
            if(![self.enrolingDonePopupSession isEqualToString:result.session]){
                self.enrolingDonePopupSession = result.session;
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"End of Session" message:@"Single session completed. Please log out and start a new session to continue enrolment." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case AMBNResultStatusAuthenticating: {
            self.statusLabelValue.text = @"Authenticating";
            self.scoreLabel.text = @"Score:";
            
            if([result.score floatValue] >= 0.6){
                [self.debugView setBackgroundColor:[self goodScoreColor]];
            }else if ([result.score floatValue] > 0.4){
                [self.debugView setBackgroundColor:[self mediumScoreColor]];
            }else{
                [self.debugView setBackgroundColor:[self badScoreColor]];
            }

            
            break;
        }
        case AMBNResultDemoStatusAuthenticatingDone: {
            self.statusLabelValue.text = @"Authenticating (end of session)";
            self.scoreLabel.text = @"Score:";
            
            if([result.score floatValue] >= 0.6){
                [self.debugView setBackgroundColor:[self goodScoreColor]];
            }else if ([result.score floatValue] > 0.4){
                [self.debugView setBackgroundColor:[self mediumScoreColor]];
            }else{
                [self.debugView setBackgroundColor:[self badScoreColor]];
            }
            
            if(![self.authenticatingDonePopupSession isEqualToString:result.session]){
                self.authenticatingDonePopupSession = result.session;
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"End of Session" message:@"Single session completed. You can see the session score in the top banner." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        
        default:
        break;
    }

    [self updateLastUpdate];
}
-(UIColor *) unknownColor {
    return [UIColor colorWithRed:203.0/255 green:199.0/255 blue:35.0/255 alpha:1];
}
-(UIColor *) mediumScoreColor {
    return [UIColor colorWithRed:203.0/255 green:199.0/255 blue:35.0/255 alpha:1];
}
-(UIColor *) badScoreColor {
    return [UIColor colorWithRed:219.0/255 green:68.0/255 blue:55.0/255 alpha:1];
}
-(UIColor *) goodScoreColor {
    return [UIColor colorWithRed:15.0/255 green:157.0/255 blue:88.0/255 alpha:1];
}
@end
