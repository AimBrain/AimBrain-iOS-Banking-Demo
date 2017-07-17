
#import <Foundation/Foundation.h>


@interface AMBNTimeTools : NSObject

/**
 Returns amount of time the system has been awake since the last time it was restarted
 This method ensures proper logic is used in all app.
 
 @return system up time
 */
+ (NSInteger)systemUpTime;

/**
 Returns amount of time the system has been awake since the last time it was restarted in milliseconds
 This method ensures proper logic is used in all app.
 
 @return system up time in milliseconds as integer.
 */
+ (NSInteger)systemUpTimeInMilliseconds;

@end
