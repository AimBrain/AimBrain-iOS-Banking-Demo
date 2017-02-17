#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define AMBNVoiceRecordingManagerErrorDomain @"AMBNVoiceRecordingManagerErrorDomain"
#define AMBNVoiceRecordingManagerMissingAudioPermissionError 2

@class AMBNVoiceRecordingViewController;

@interface AMBNVoiceRecordingManager : NSObject

- (AMBNVoiceRecordingViewController *)instantiateVoiceRecordingViewControllerWithAudioLength:(NSTimeInterval)audioLength;
- (AMBNVoiceRecordingViewController *)instantiateVoiceRecordingViewControllerWithTopHint:(NSString*)topHint bottomHint:(NSString *)bottomHint recordingHint:(NSString *)recordingHint audioLength:(NSTimeInterval)audioLength;

@end
