
#import <UIKit/UIKit.h>
#import "AMBNCameraOverlayDelegate.h"

@interface AMBNCameraOverlay : UIView

@property (weak, nonatomic) IBOutlet UIView *faceOval;
@property (nonatomic, weak) id <AMBNCameraOverlayDelegate> delegate;
@property (nonatomic, weak) UIImagePickerController *imagePicker;
@property int toCapture;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property NSLayoutConstraint *previewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *previewOverlay;
@property (weak, nonatomic) IBOutlet UILabel *topHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomHintLabel;

@end
