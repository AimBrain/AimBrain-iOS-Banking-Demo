@import UIKit;
@import AVFoundation;
#import "AMBNFaceRecordingViewControllerDelegate.h"

#define AMBNFaceCaptureManagerErrorDomain @"AMBNFaceCaptureManagerErrorDomain"
#define AMBNFaceCaptureManagerMissingVideoPermissionError 1

@interface AMBNFaceRecordingViewController : UIViewController <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, weak) id <AMBNFaceRecordingViewControllerDelegate> delegate;
/*!
 @description top hint displayed on video capture view
 */
@property NSString *topHint;

/*!
 @description bottom hint displayed on video capture view
 */
@property NSString *bottomHint;

/*!
 @description bottom hint displayed while recording
 */
@property NSString *recordingHint;

/*!
 @description length of recorded video
 */
@property NSTimeInterval videoLength;

@end