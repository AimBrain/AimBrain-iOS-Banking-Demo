@import Foundation;

#define AMBNResultStatusEnrolling 0
#define AMBNResultStatusAuthenticating 1

/*!
 @discussion This class contains information about result of behavioral analysis
 */
@interface AMBNResult : NSObject

/*!
 @discussion Score is value between 0 and 1.
 */
@property NSNumber * score;

/*!
 @discussion Behavioral analysis engine learning status.
 */
@property  NSInteger status;

/*!
 @discussion Session.
 */
@property  NSString * session;

- (instancetype) initWithScore: (NSNumber *) score status: (NSInteger) status session: (NSString *) session;

@end
