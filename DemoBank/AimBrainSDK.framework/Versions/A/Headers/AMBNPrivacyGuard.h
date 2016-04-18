@import Foundation;
@import UIKit;

/*!
 @discussion Class used to keep and free non-capturing guards on selected views. Instances of this class must be created using instance of @link AMBNManager @/link class. Typical usecase is to store reference to this object as long as there is need to exclude given views from capturing. Then call @link invalidate @/link method and remove the refernce. 
 */
@interface AMBNPrivacyGuard : NSObject

/*!
 @discussion Array of views excluded from beahvioural data capturing
 */
@property NSArray * views;

/*!
  @discussion If true, then all views are excluded from capturing. This property has precedence over @link views @/link.
 */
@property BOOL allViews;

/*!
 @discussion This property is true after privacy guard is invalidated.
 */
@property (readonly) BOOL valid;

/*!
 @discussion Initializes guard. Privacy guard will disable capturing only if obtained using AMBNManager.
 @param views Views excluded from capturing.
 */
-(instancetype)initWithViews:(NSArray *) views;

/*!
 @discussion Initializes guard with allViews set to true. Privacy guard will disable capturing only if obtained using AMBNManager.
 */
-(instancetype)initWithAllViews;

/*!
 @discussion Invalidates guard. Calling this method causes guard to stop preventing from capturing.
 */
-(void)invalidate;

/*!
 @discussion method used to test wheter given view is protected and should be ignored.
 @param view View to test.
 */
-(BOOL)isViewIgnored:(UIView *) view;

@end
