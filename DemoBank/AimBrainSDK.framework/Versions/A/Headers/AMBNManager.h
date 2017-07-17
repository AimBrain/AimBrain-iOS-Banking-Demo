@import Foundation;

#import "AMBNPrivacyGuard.h"
#import "AMBNTextInputCollectorDelegate.h"
#import "AMBNTouchCollectorDelegate.h"
#import "AMBNFaceRecordingViewController.h"
#import "AMBNResult.h"
#import "AMBNLogConstants.h"

@class AMBNSessionCreateResult;
@class AMBNBehaviouralResult;
@class AMBNEnrollFaceResult;
@class AMBNAuthenticateResult;
@class AMBNCompareFaceResult;
@class AMBNSerializedRequest;
@class AMBNVoiceRecordingViewController;
@class AMBNEnrollVoiceResult;
@class AMBNVoiceTextResult;

/*!
 @define AMBNManagerBehaviouralDataSubmittedNotification behavioural data subsmission notification
 */
#define AMBNManagerBehaviouralDataSubmittedNotification @"behaviouralDataSubmitted"

typedef NS_ENUM(NSInteger, AMBNVoiceTokenType) {
    AMBNVoiceTokenTypeEnroll1 = 1,
    AMBNVoiceTokenTypeEnroll2 = 2,
    AMBNVoiceTokenTypeEnroll3 = 3,
    AMBNVoiceTokenTypeEnroll4 = 4,
    AMBNVoiceTokenTypeEnroll5 = 5,
    AMBNVoiceTokenTypeAuth = 100
};

/**
 Value for unlimited memory usage.
 */
static const NSInteger kAMBNMemoryUsageUnlimited = 0;

/*!
 @class AMBNManager
 @discussion AMBNManager provides centralized interface for collecting behavioural data and communicating with AimBrain API
*/
@interface AMBNManager : NSObject <AMBNTextInputCollectorDelegate, AMBNTouchCollectorDelegate>

/*!
 @discussion Behavioural data collecting state.
 */
@property(readonly) BOOL started;

/*!
 @discussion Session must be set before submitting behavioural data. Instead of setting this propery you can also obtain session using @link configureWithApiKey:secret: @/link
 */
@property NSString *session;

/*!
 @discussion Maximum allowed memory in kilobytes for event collection. Default value is `kAMBNMemoryUsageUnlimited`
 */
@property (nonatomic, assign) NSInteger memoryUsageLimitKB;

/*!
 @description Use this method to get AMBNManager singleton.
 @return AMBNManager singleton.
 */
+ (instancetype)sharedInstance;

#pragma mark - logging

/**
 Enables or disabled logging.
 Default is enabled. Console messages depend on set LogLevel.
 
 @param isEnabled If "YES", console logging is enabled.
 */
+ (void)setLoggingEnabled:(BOOL)isEnabled;

/**
 Sets log level.
 Default is "AMBNLogLevelWarn".
 If Logging is disabled, will ignore level setting.
 
 @param level The desired "AMBNLogLevel" log level.
 */
+ (void)setLogLevel:(AMBNLogLevel)level;

/**
 Returns the desired "AMBNLogLevel".
 If Logging is disabled, will ignore level setting.
 
 @return log level.
 */
+ (AMBNLogLevel)logLevel;

/*!
 @description Starts behavioural data collection.
 */
- (void)start;

/*!
 @description Configures AMBNManager. This method must be called before creating user session or submitting behavioural data.
 @param apiKey Provided application identifier.
 @param appSecret Provided application secret.
 */
- (void)configureWithApiKey:(NSString *)apiKey secret:(NSString *)appSecret;

/*!
 @description Configures AMBNManager. This method must be called before creating user session or submitting behavioural data.
 @param apiKey Provided application identifier.
 @param appSecret Provided application secret.
 @param baseUrl Provided server base URL string.
 */
- (void)configureWithApiKey:(NSString *)apiKey secret:(NSString *)appSecret baseUrl:(NSString *)baseUrl;

/*!
 @description Creates session key and sets session property of this class.
 @param userId user identifier.
 @param completion Called when session obtainment completes. Session is successfuly obtained if session <b> session </b> is not nil and <b> error </b> is nil.
 */
- (void)createSessionWithUserId:(NSString *)userId completion:(void (^)(NSString *session, NSNumber *face, NSNumber *behaviour, NSError *error))completion DEPRECATED_MSG_ATTRIBUTE("use createSessionWithUserId:completionHandler:");

/*!
 @description Creates session key and sets session property of this class.
 @param userId user identifier.
 @param completion Called when session obtainment completes. Session is successfuly obtained if <b> result.session </b> is not nil and <b> error </b> is nil.
 */
- (void)createSessionWithUserId:(NSString *)userId completionHandler:(void (^)(AMBNSessionCreateResult *result, NSError *error))completion;

/*!
 @description Creates session key and sets session property of this class.
 @param userId user identifier.
 @param metadata metadata to be sent with request
 @param completion Called when session obtainment completes. Session is successfuly obtained if <b> result.session </b> is not nil and <b> error </b> is nil.
 */
- (void)createSessionWithUserId:(NSString *)userId metadata:(NSData *)metadata completionHandler:(void (^)(AMBNSessionCreateResult *result, NSError *error))completion;

/*!
 @description Serialized create session request.
 @param userId user identifier.
 @param metadata metadata to be included with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedCreateSessionWithUserId:(NSString *)userId metadata:(NSData *)metadata;

/*!
 @description Submits collected behavioural data. @link session @/link property must be set before using this method.
 @param completion Called when submitting completes. Submission was successful if <b> score </b> is not nil and <b> error </b> is nil.
 */
- (void)submitBehaviouralDataWithCompletion:(void (^)(AMBNResult *result, NSError *error))completion DEPRECATED_MSG_ATTRIBUTE("use submitBehaviouralDataWithCompletionHandler:");

/*!
 @description Submits collected behavioural data. @link session @/link property must be set before using this method.
 @param completion Called when submitting completes. Submission was successful if <b> result.score </b> is not nil and <b> error </b> is nil.
 */
- (void)submitBehaviouralDataWithCompletionHandler:(void (^)(AMBNBehaviouralResult *result, NSError *error))completion;

/*!
 @description Submits collected behavioural data. @link session @/link property must be set before using this method.
 @param metadata metadata to be sent with request
 @param completion Called when submitting completes. Submission was successful if <b> result.score </b> is not nil and <b> error </b> is nil.
 */
- (void)submitBehaviouralDataWithMetadata:(NSData *)metadata completionHandler:(void (^)(AMBNBehaviouralResult *result, NSError *error))completion;

/*!
 @description Serialized collected behavioural data. @link session @/link property must be set before using this method.
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedSubmitBehaviouralDataWithMetadata:(NSData *)metadata;

/*!
 @description Gets current behavioural score.
 @param completion Called when getting score completes. Fetch was successful if <b> result.score </b> is not nil and <b> error </b> is nil.
 */
- (void)getScoreWithCompletion:(void (^)(AMBNResult *result, NSError *error))completion DEPRECATED_MSG_ATTRIBUTE("use getScoreWithCompletionHandler:");;

/*!
@description Gets current behavioural score.
 @param completion Called when submitting completes. Submission was successful if <b> result </b> is not nil and <b> error </b> is nil.
 */
- (void)getScoreWithCompletionHandler:(void (^)(AMBNBehaviouralResult *result, NSError *error))completion;

/*!
 @description Gets current behavioural score.
 @param metadata metadata to be sent with request
 @param completion Called when submitting completes. Submission was successful if <b> result </b> is not nil and <b> error </b> is nil.
 */
- (void)getScoreWithMetadata:(NSData *)metadata completionHandler:(void (^)(AMBNBehaviouralResult *result, NSError *error))completion;

/*!
 @description Serializes Request to gets current behavioural score.
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedGetScoreWithMetadata:(NSData *)metadata;

/*!
 @description Clears collected behavioural data. Use this method to clear collected data for some specific cases e.g. before entering a pin code when no session available.
 */
- (void)clearBehaviouralData;

/*!
 @description Assigns string identifier to view. Registering views increases precision of behavioural data analysis.
 @param view Registered view.
 @param identifier identifier to be assigned.
 */
- (void)registerView:(UIView *)view withId:(NSString *)identifier;

/*!
 @description Completely disables behavioural data capturing.
 @return Capturing is disabled until @link invalidate @/link method of privacy guard is called or privacy guard is garbage collected. In order to keep capturing disabled, reference to this object must be stored.
 */
- (AMBNPrivacyGuard *)disableCapturingForAllViews;

/*!
 @description Disables behavioural data capturing for events which happened inside any of given views.
 @param views Array of views for which events will not be captured.
 @return Capturing is disabled until @link invalidate @/link method of privacy guard is called or privacy guard is garbage collected. In order to keep capturing disabled, reference to this object must be stored.
 */
- (AMBNPrivacyGuard *)disableCapturingForViews:(NSArray *)views;

/*!
 @description Behavioural data of sensitve view is submitted without absoulte position and with hashed object id. Before using this method set sensitive salt.
 @param views Array of sensitive views.
 */
- (void)addSensitiveViews:(NSArray *)views;

/*!
 @description Sets salt used for generating hashed object ids.
 @param salt 128 bit data being secure generated salt
 */
- (void)setSensitiveSalt:(NSData *)salt;

/*!
 @description Generates secure 128 bit salt
 */
- (NSData *)generateRandomSensitiveSalt;

/*!
 @description Enrolls face images. 
 @param images array of face images to enroll
 @param completion called when enrollement is completed. <b> Success </b> is true when enrollment was successful. <b> Images count </b> is number of images succesfully enrolled
 */
- (void)enrollFaceImages:(NSArray *)images completion:(void (^)(BOOL success, NSNumber *imagesCount, NSError *error))completion DEPRECATED_MSG_ATTRIBUTE("use enrollFaceImages:completionHandler:");

/*!
 @description Enrolls face images.
 @param completion Called when submitting completes. Submission was successful if <b> result.score </b> is not nil and <b> error </b> is nil.
 */
- (void)enrollFaceImages:(NSArray *)images completionHandler:(void (^)(AMBNEnrollFaceResult *result, NSError *error))completion;

/*!
 @description Enrolls face images.
 @param metadata metadata to be sent with request
 @param completion Called when submitting completes. Submission was successful if <b> result.score </b> is not nil and <b> error </b> is nil.
 */
- (void)enrollFaceImages:(NSArray *)images metadata:(NSData *)metadata completionHandler:(void (^)(AMBNEnrollFaceResult *result, NSError *error))completion;

/*!
 @description Serializes request to enroll face images.
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedEnrollFaceImages:(NSArray *)images metadata:(NSData *)metadata;

/*!
 @description Authenticates face images.
 @param images array of face images to authenticate
 @param completion called when authentication is completed. <b> score </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled face. <b> liveliness </b> is floating point number from 0 to 1 indicating liveliness of the image batch where 1 is maximum liveliness.
 */
- (void)authenticateFaceImages:(NSArray *)images completion:(void (^)(NSNumber *score, NSNumber *liveliness, NSError *error))completion DEPRECATED_MSG_ATTRIBUTE("use authenticateFaceImages:completionHandler:");

/*!
 @description Authenticates face images.
 @param images array of face images to authenticate
 @param completion called when authentication is completed. <b> result.score </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled face. <b> result.liveliness </b> is floating point number from 0 to 1 indicating liveliness of the image batch where 1 is maximum liveliness.
 */
- (void)authenticateFaceImages:(NSArray *)images completionHandler:(void (^)(AMBNAuthenticateResult *result, NSError *error))completion;

/*!
 @description Authenticates face images.
 @param images array of face images to authenticate
 @param metadata metadata to be sent with request
 @param completion called when authentication is completed. <b> result.score </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled face. <b> result.liveliness </b> is floating point number from 0 to 1 indicating liveliness of the image batch where 1 is maximum liveliness.
 */
- (void)authenticateFaceImages:(NSArray *)images metadata:(NSData *)metadata completionHandler:(void (^)(AMBNAuthenticateResult *result, NSError *error))completion;

/*!
 @description Serializes request to authenticates face images.
 @param images array of face images to authenticate
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedAuthenticateFaceImages:(NSArray *)images metadata:(NSData *)metadata;

/*!
 @description Compares faces
 @param firstFaceImages array of first face images to compare
 @param secondFaceImages array of second face images to compare
 @param completion called when comparing is completed. <b> result.score </b> is floating point number from 0 to 1 where 1 is maximum similarity. <b> result.firstLiveliness </b> is liveliness of the first photo array. <b> result.secondLiveliness </b> is liveliness of the second photo array
 */
- (void)compareFaceImages:(NSArray *)firstFaceImages toFaceImages:(NSArray *)secondFaceImages completion:(void (^)(NSNumber *score, NSNumber *firstLiveliness, NSNumber *secondLiveliness, NSError *error))completion  DEPRECATED_MSG_ATTRIBUTE("use compareFaceImages:toFaceImages:completionHandler:");

/*!
 @description Compares faces
 @param firstFaceImages array of first face images to compare
 @param secondFaceImages array of second face images to compare
 @param completion called when comparing is completed. <b> result.score </b> is floating point number from 0 to 1 where 1 is maximum similarity. <b> result.firstLiveliness </b> is liveliness of the first photo array. <b> result.secondLiveliness </b> is liveliness of the second photo array
 */
- (void)compareFaceImages:(NSArray *)firstFaceImages toFaceImages:(NSArray *)secondFaceImages completionHandler:(void (^)(AMBNCompareFaceResult *result, NSError *error))completion;

/*!
 @description Compares faces
 @param firstFaceImages array of first face images to compare
 @param secondFaceImages array of second face images to compare
 @param metadata metadata to be sent with request
 @param completion called when comparing is completed. <b> result.score </b> is floating point number from 0 to 1 where 1 is maximum similarity. <b> result.firstLiveliness </b> is liveliness of the first photo array. <b> result.secondLiveliness </b> is liveliness of the second photo array
 */
- (void)compareFaceImages:(NSArray *)firstFaceImages toFaceImages:(NSArray *)secondFaceImages metadata:(NSData *)metadata completionHandler:(void (^)(AMBNCompareFaceResult *result, NSError *error))completion;

/*!
 @description Serializes request to compare faces
 @param firstFaceImages array of first face images to compare
 @param secondFaceImages array of second face images to compare
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedCompareFaceImages:(NSArray *)firstFaceImages toFaceImages:(NSArray *)secondFaceImages metadata:(NSData *)metadata;

/*!
 @description Opens view controller used to capture and crop face images
 @param topHint top hint displayed on image capture view
 @param bottomHint bottom hint displayed on image capture view
 @param batchSize number of images to capture
 @param viewController current view controller used to perform transition to image capture controller
 @param completion called when capturing is completed and image capture view controller is dismissed. <b> error </b> is nil when images are successfuly captured. <b> images </b> is array of taken UIImage objects.
 */
- (void)openFaceImagesCaptureWithTopHint:(NSString *)topHint bottomHint:(NSString *)bottomHint batchSize:(NSInteger)batchSize delay:(NSTimeInterval)delay fromViewController:(UIViewController *)viewController completion:(void (^)(NSArray *images, NSError *error))completion;

/*!
 @description Returns view controller used to capture face video
 @param videoLength length of recorded video
 */
- (AMBNFaceRecordingViewController *)instantiateFaceRecordingViewControllerWithVideoLength:(NSTimeInterval)videoLength;

/*!
 @description Returns view controller used to capture face video
 @param topHint top hint displayed on video capture view
 @param bottomHint bottom hint displayed on video capture view
 @param recordingHint bottom hint displayed while recording
 @param videoLength length of recorded video
 */
- (AMBNFaceRecordingViewController *)instantiateFaceRecordingViewControllerWithTopHint:(NSString *)topHint
                                                                            bottomHint:(NSString *)bottomHint
                                                                         recordingHint:(NSString *)recordingHint
                                                                           videoLength:(NSTimeInterval)videoLength;

/*!
 @description Enrolls face videos.
 @param video url of face video to enroll
 @param completion called when enrollement is completed. <b> Success </b> is true when enrollment was successful.
 */
- (void)enrollFaceVideo:(NSURL *)video completion:(void (^)(BOOL success, NSError *error))completion DEPRECATED_MSG_ATTRIBUTE("use enrollFaceVideo:completionHandler:");

/*!
 @description Enrolls face videos.
 @param completion called when enrollement is completed. <b> result </b> is no nil when enrollment was successful.
 */
- (void)enrollFaceVideo:(NSURL *)video completionHandler:(void (^)(AMBNEnrollFaceResult *result, NSError *error))completion;

/*!
 @description Enrolls face videos.
 @param video url of face video to enroll
 @param metadata metadata to be sent with request
 @param completion called when enrollement is completed. <b> result </b> is no nil when enrollment was successful.
 */
- (void)enrollFaceVideo:(NSURL *)video metadata:(NSData *)metadata completionHandler:(void (^)(AMBNEnrollFaceResult *result, NSError *error))completion;

/*!
 @description Serializes request to enroll face videos
 @param video url of face video to enroll
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedEnrollFaceVideo:(NSURL *)video metadata:(NSData *)metadata;

/*!
 @description Authenticates face video.
 @param video url of face video to authenticate
 @param completion called when authentication is completed. <b> score </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled face. <b> liveliness </b> is floating point number from 0 to 1 indicating liveliness of the video where 1 is maximum liveliness.
 */
- (void)authenticateFaceVideo:(NSURL *)video completion:(void (^)(NSNumber *score, NSNumber *liveliness, NSError *error))completion DEPRECATED_MSG_ATTRIBUTE("use authenticateFaceVideo:completionHandler:");

/*!
 @description Authenticates face video.
 @param video url of face video to authenticate
 @param completion called when authentication is completed. <b> result.score </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled face. <b> result.liveliness </b> is floating point number from 0 to 1 indicating liveliness of the video where 1 is maximum liveliness.
 */
- (void)authenticateFaceVideo:(NSURL *)video completionHandler:(void (^)(AMBNAuthenticateResult *result, NSError *error))completion;

/*!
 @description Authenticates face video.
 @param video url of face video to authenticate
 @param metadata metadata to be sent with request
 @param completion called when authentication is completed. <b> result.score </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled face. <b> result.liveliness </b> is floating point number from 0 to 1 indicating liveliness of the video where 1 is maximum liveliness.
 */
- (void)authenticateFaceVideo:(NSURL *)video metadata:(NSData *)metadata completionHandler:(void (^)(AMBNAuthenticateResult *result, NSError *error))completion;

/*!
 @description Serializes request to authenticates face video
 @param video url of face video to authenticate
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedAuthenticateFaceVideo:(NSURL *)video metadata:(NSData *)metadata;

/*!
 @description Returns view controller used to capture voice audio
 @param audioLength length of recorded audio
 */
- (AMBNVoiceRecordingViewController *) instantiateVoiceRecordingViewControllerWithAudioLength:(NSTimeInterval)audioLength;

/*!
 @description Returns view controller used to capture voice audio
 @param topHint top hint displayed on audio capture view
 @param bottomHint bottom hint displayed on audio capture view
 @param recordingHint bottom hint displayed while recording
 @param audioLength length of recorded audio
 */
- (AMBNVoiceRecordingViewController *) instantiateVoiceRecordingViewControllerWithTopHint:(NSString *)topHint
                                                                               bottomHint:(NSString *)bottomHint
                                                                            recordingHint:(NSString *)recordingHint
                                                                              audioLength:(NSTimeInterval)audioLength;

/*!
 @description Enrolls voice record.
 @param voiceFileUrl of voice record to authenticate
 @param completion called when enrollement is completed. <b> result </b> is no nil when enrollment was successful.
 */
- (void)enrollVoice:(NSURL *)voiceFileUrl completionHandler:(void (^)(AMBNEnrollVoiceResult *result, NSError *))completion;

/*!
 @description Enrolls voice record.
 @param voiceFileUrl URL of voice record to authenticate
 @param metadata metadata to be sent with request
 @param completion called when enrollement is completed. <b> result </b> is no nil when enrollment was successful.
 */
- (void)enrollVoice:(NSURL *)voiceFileUrl metadata:(NSData *)metadata completionHandler:(void (^)(AMBNEnrollVoiceResult *result, NSError *))completion;

/*!
 @description Serializes request to enroll voice record
 @param voiceFileUrl URL of voice record to authenticate
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedEnrollVoice:(NSURL *)voiceFileUrl metadata:(NSData *)metadata;

/*!
 @description Authenticates voice record.
 @param voiceUrl of voice record to authenticate
 @param completion called when authentication is completed. <b> score </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled voice. <b> liveliness </b> is floating point number from 0 to 1 indicating liveliness of the record where 1 is maximum liveliness.
 */
- (void)authenticateVoice:(NSURL *)voiceUrl completionHandler:(void (^)(AMBNAuthenticateResult *result, NSError *error))completion;

/*!
 @description Authenticates voice record.
 @param voiceFileUrl url of voice record to authenticate
 @param metadata metadata to be sent with request
 @param completion called when authentication is completed. <b> score </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled voice. <b> liveliness </b> is floating point number from 0 to 1 indicating liveliness of the record where 1 is maximum liveliness.
 */
- (void)authenticateVoice:(NSURL *)voiceFileUrl metadata:(NSData *)metadata completionHandler:(void (^)(AMBNAuthenticateResult *result, NSError *error))completion;

/*!
 @description Serializes request to authenticate voice record
 @param voiceFileUrl url of voice record to authenticate
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedAuthenticateVoice:(NSURL *)voiceFileUrl metadata:(NSData *)metadata;

/*!
 @description Retrieves text to read in case of voice auth/enroll.
 @param type token type
 @param completion called when request is completed. <b> result.text </b> is text to be displayed in recording UI
 */
- (void)getVoiceTokenWithType:(AMBNVoiceTokenType)type completionHandler:(void (^)(AMBNVoiceTextResult *, NSError *))completion;

/*!
 @description Retrieves text to read in case of voice auth/enroll.
 @param type token type
 @param metadata metadata to be sent with request
 @param completion called when request is completed. <b> result.text </b> is text to be displayed in recording UI
 */
- (void)getVoiceTokenWithType:(AMBNVoiceTokenType)type metadata:(NSData *)metadata completionHandler:(void (^)(AMBNVoiceTextResult *result, NSError * error))completion;

/*!
 @description Serializes request to retrieve text to read in case of voice auth/enroll
 @param type token type
 @param metadata metadata to be sent with request
 @return serialized data.
 */
- (AMBNSerializedRequest *)getSerializedGetVoiceTokenWithType:(AMBNVoiceTokenType)type metadata:(NSData *)metadata;

@end
