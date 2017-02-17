@import Foundation;
@class AMBNVoiceRecordingViewController;

@protocol AMBNVoiceRecordingViewControllerDelegate <NSObject>

/*!
 @description Returns recorded audio or error if occured, this method is called after finish or interruption of recording
 @param voiceRecordingViewController view controller from which this method is called
 @param audio recorded audio if no errors occured
 @param error error if occured
 */
- (void)voiceRecordingViewController:(AMBNVoiceRecordingViewController *)voiceRecordingViewController recordingResult:(NSURL *)audio error:(NSError *)error;

@optional
- (void)voiceRecordingViewControllerClosedByUser;

@end