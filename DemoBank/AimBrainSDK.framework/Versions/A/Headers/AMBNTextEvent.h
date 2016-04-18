@import Foundation;

@interface AMBNTextEvent : NSObject

@property NSString * text;
@property int timestamp;
@property NSArray * identifiers;

-(instancetype) initWithText: (NSString*) text timestamp: (int) timestamp identifiers: (NSArray *)identifiers;
@end
