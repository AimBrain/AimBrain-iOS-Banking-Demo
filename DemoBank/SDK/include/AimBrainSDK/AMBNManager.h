#import <Foundation/Foundation.h>
#import "AMBNPrivacyGuard.h"
#import "AMBNTextInputCollectorDelegate.h"
#import "AMBNTouchCollectorDelegate.h"
#import "AMBNResult.h"

/*!
 @define AMBNManagerBehaviouralDataSubmittedNotification behavioural data subsmission notification
 */
#define AMBNManagerBehaviouralDataSubmittedNotification @"behaviouralDataSubmitted"



/*!
 @class AMBNManager
 @discussion AMBNManager provides centralized interface for collecting behavioural data and communicating with AimBrain API
*/
@interface AMBNManager : NSObject <AMBNTextInputCollectorDelegate, AMBNTouchCollectorDelegate>

/*!
 @discussion Behavioural data collecting state.
 */
@property (readonly) BOOL started;

/*!
 @discussion Session must be set before submitting behavioural data. Instead of setting this propery you can also obtain session using @link configureWithApplicationId:secret: @/link
 */
@property NSString * session;

/*!
 @description Use this method to get AMBNManager singleton.
 @return AMBNManager singleton.
 */
+ (instancetype) sharedInstance;

/*!
 @description Starts behavioural data collection.
 */
- (void) start;

/*!
 @description Configures AMBNManager. This method must be called before creating user session or submitting behavioural data.
 @param appId Provided application identifier.
 @param appSecret Provided application secret.
 */
- (void) configureWithApplicationId: (NSString *) appId secret: (NSString *) appSecret;

/*!
 @description Creates session key and sets session property of this class.
 @param userId user identifier.
 @param completion Called when session obtainment completes. Session is successfuly obtained if session <b> session </b> is not nil and <b> error </b> is nil.
 */
- (void) createSessionWithUserId: (NSString *) userId completion: (void (^)(NSString * session, NSNumber * face, NSNumber * behaviour, NSError *error))completion;

/*!
 @description Submits collected behavioural data. @link session @/link property must be set before using this method.
 @param completion Called when submitting completes. Submission was successful if <b> score </b> is not nil and <b> error </b> is nil.
 */
- (void) submitBehaviouralDataWithCompletion:(void (^)(AMBNResult * result, NSError *error))completion;

/*!
 @description Gets current behavioural score.
 @param completion Called when getting score completes. Fetch was successful if <b> score </b> is not nil and <b> error </b> is nil.
 */
- (void) getScoreWithCompletion:(void (^)(AMBNResult * result, NSError *error))completion;

/*!
 @description Assigns string identifier to view. Registering views increases precision of behavioural data analysis.
 @param view Registered view.
 @param identifier identifier to be assigned.
 */

- (void) registerView:(UIView *) view withId:(NSString *) identifier;


/*!
 @description Completely disables behavioural data capturing.
 @return Capturing is disabled until @link invalidate @/link method of privacy guard is called or privacy guard is garbage collected. In order to keep capturing disabled, reference to this object must be stored.
 */
- (AMBNPrivacyGuard *) disableCapturingForAllViews;



/*!
 @description Disables behavioural data capturing for events which happened inside any of given views.
 @param views Array of views for which events will not be captured.
 @return Capturing is disabled until @link invalidate @/link method of privacy guard is called or privacy guard is garbage collected. In order to keep capturing disabled, reference to this object must be stored.
 */
- (AMBNPrivacyGuard *) disableCapturingForViews:(NSArray *) views;


/*!
 @description Behavioural data of sensitve view is submitted without absoulte position and with hashed object id. Before using this method set sensitive salt.
 @param views Array of sensitive views.
 */
- (void) addSensitiveViews:(NSArray *) views;

/*!
 @description Sets salt used for generating hashed object ids.
 @param salt 128 bit data being secure generated salt
 */
- (void) setSensitiveSalt:(NSData *)salt;

/*!
 @description Generates secure 128 bit salt
 */
- (NSData *)generateRandomSensitiveSalt;

/*!
 @description Enrolls face images. 
 @param images array of face images to enroll
 @param completion called when enrollement is completed. <b> Success </b> is true when enrollment was successful. <b> Images count </b> is number of images succesfully enrolled
 */
- (void) enrollFaceImages:(NSArray *) images completion:(void (^)(BOOL success, NSNumber * imagesCount, NSError * error)) completion;

/*!
 @description Authenticates face images.
 @param images array of face images to authenticate
 @param completion called when authentication is completed. <b> result </b> is floating point number from 0 to 1 where 1 is maximum similarity to enrolled face. <b> liveliness <\b> is floating point number from 0 to 1 indicating liveliness of the image batch where 1 is maximum liveliness.
 */
- (void) authenticateFaceImages:(NSArray *)images completion: (void (^)(NSNumber * result, NSNumber * liveliness, NSError * error))completion;

/*!
 @description Compares faces
 @param firstFaceImages array of first face images to compare
 @param secondFaceImages array of second face images to compare
 @param completion called when comparing is completed. <b> result </b> is floating point number from 0 to 1 where 1 is maximum similarity. <b> firstLiveliness </b> is liveliness of the first photo array. <b> secondLiveliness </b> is liveliness of the second photo array
 */
- (void) compareFaceImages:(NSArray *) firstFaceImages toFaceImages:(NSArray *) secondFaceImages completion: (void (^)(NSNumber * result, NSNumber * firstLiveliness, NSNumber * secondLiveliness, NSError * error))completion;

/*!
 @description Opens view controller used to capture and crop face images
 @param topHint top hint displayed on image capture view
 @param bottomHint bottom hint displayed on image capture view
 @param batchSize number of images to capture
 @param viewController current view controller used to perform transition to image capture controller
 @param completion called when capturing is completed and image capture view controller is dismissed. <b> success </b> is true when images are successfuly captured. <b> images </b> is array of taken UIImage objects.
 */
- (void) openFaceImagesCaptureWithTopHint: (NSString *) topHint bottomHint:(NSString *) bottomHint batchSize: (NSInteger) batchSize delay: (NSTimeInterval) delay fromViewController: (UIViewController *) viewController completion: (void (^)(BOOL success, NSArray * images))completion;



@end
