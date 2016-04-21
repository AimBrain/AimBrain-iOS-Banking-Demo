#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AMBNCameraPreview.h"
#import "AMBNFaceRecordingViewController.h"

@interface AMBNCaptureSessionConfigurator : NSObject

- (AVCaptureSession *)getConfiguredSessionWithMaxVideoLength:(NSTimeInterval)videoLength andCameraPreview:(AMBNCameraPreview *)cameraPreview;
- (void)recordVideoFrom:(AMBNFaceRecordingViewController *)recordingViewController;

@end