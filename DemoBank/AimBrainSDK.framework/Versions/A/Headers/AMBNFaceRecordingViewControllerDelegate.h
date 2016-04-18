@import Foundation;
#import "AMBNFaceRecordingViewController.h"
@class AMBNFaceRecordingViewController;

@protocol AMBNFaceRecordingViewControllerDelegate <NSObject>

/*!
 @description Returns recorded video or error if occured, this method is called after finish or interruption of recording
 @param faceRecordingViewController view controller from which this method is called
 @param video recorded video if no errors occured
 @param error error if occured
 */
- (void)faceRecordingViewController:(AMBNFaceRecordingViewController *)faceRecordingViewController recordingResult:(NSURL *)video error:(NSError *)error;

@end