#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AMBNCameraPreview : UIView

- (void)setupPreviewLayer:(AVCaptureVideoPreviewLayer *)layer;

@end