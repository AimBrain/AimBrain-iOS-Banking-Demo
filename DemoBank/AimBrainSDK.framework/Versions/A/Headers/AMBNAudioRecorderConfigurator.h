#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AMBNVoiceRecordingViewController.h"

@interface AMBNAudioRecorderConfigurator : NSObject

- (AVAudioRecorder *)getConfiguredRecorderWithMaxAudioLength:(NSTimeInterval)audioLength;
- (BOOL)recordAudioFrom:(AMBNVoiceRecordingViewController *)recordingViewController;
- (void)stopRecording;
- (void)startPlaying;
- (void)stopPlaying;

@end