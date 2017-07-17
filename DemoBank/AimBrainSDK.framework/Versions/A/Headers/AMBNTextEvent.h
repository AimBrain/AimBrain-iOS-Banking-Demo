
#import "AMBNBaseEvent.h"

@interface AMBNTextEvent : AMBNBaseEvent

@property NSString * text;
@property NSArray * identifiers;

-(instancetype) initWithText: (NSString*) text timestamp: (int) timestamp identifiers: (NSArray *)identifiers;
@end
