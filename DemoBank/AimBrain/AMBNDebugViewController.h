#import <UIKit/UIKit.h>

@interface AMBNDebugViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *debugView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabelValue;
@property NSTimer * timer;
@end
