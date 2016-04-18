#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AMBNCameraOverlayDelegate.h"
#import "AMBNFaceRecordingViewController.h"

#define AMBNFaceCaptureManagerErrorDomain @"AMBNFaceCaptureManagerErrorDomain"
#define AMBNFaceCaptureManagerMissingVideoPermissionError 1


@interface AMBNFaceCaptureManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMBNCameraOverlayDelegate>


- (void) openCaptureViewFromViewController:(UIViewController *) viewController topHint:(NSString*)topHint bottomHint: (NSString *) bottomHint batchSize: (NSInteger) batchSize delay: (NSTimeInterval) delay completion:(void (^)(NSArray * images, NSError * error))completion;
- (AMBNFaceRecordingViewController *)instantiateFaceRecordingViewControllerWithMovieLength:(NSTimeInterval)movieLength;
- (AMBNFaceRecordingViewController *)instantiateFaceRecordingViewControllerWithTopHint:(NSString*)topHint bottomHint:(NSString *)bottomHint recordingHint:(NSString *)recordingHint movieLength:(NSTimeInterval)movieLength;

@end
