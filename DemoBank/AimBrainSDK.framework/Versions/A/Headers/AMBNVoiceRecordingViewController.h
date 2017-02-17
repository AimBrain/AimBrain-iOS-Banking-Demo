#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AMBNVoiceRecordingViewControllerDelegate.h"

#define AMBNVoiceRecordingManagerErrorDomain @"AMBNVoiceRecordingManagerErrorDomain"
#define AMBNVoiceRecordingManagerMissingAudioPermissionError 2
#define AMBNVoiceRecordingManagerFinishedUnsuccessfully 3

@interface AMBNVoiceRecordingViewController : UIViewController <AVAudioRecorderDelegate>

@property (nonatomic, weak) id <AMBNVoiceRecordingViewControllerDelegate> delegate;
/*!
 @description top hint displayed on voice capture view
 */
@property NSString *topHint;

/*!
 @description bottom hint displayed on voice capture view
 */
@property NSString *bottomHint;

/*!
 @description bottom hint displayed while recording
 */
@property NSString *recordingHint;

/*!
 @description length of recorded audio
 */
@property NSTimeInterval audioLength;

@end
