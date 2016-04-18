#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AMBNCameraPreview.h"
#import "AMBNFaceRecordingViewController.h"

@interface AMBNCaptureSessionConfigurator : NSObject

- (AVCaptureSession *)getConfiguredSessionWithMaxMovieLength:(NSTimeInterval)movieLength andCameraPreview:(AMBNCameraPreview *)cameraPreview;
- (void)recordMovieFrom:(AMBNFaceRecordingViewController *)recordingViewController;

@end