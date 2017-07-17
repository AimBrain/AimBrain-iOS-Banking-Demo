#import <Foundation/Foundation.h>
#import "AMBNTextInputCollectorDelegate.h"
#import "AMBNViewIdChainExtractor.h"

typedef void(^EventCollectorBlock)(void);

@class AMBNEventBuffer;

@interface AMBNTextInputCollector : NSObject

@property (nonatomic, weak) id delegate;
@property NSData * sensitiveSalt;

-(instancetype)initWithBuffer:(AMBNEventBuffer *)buffer idExtractor:(AMBNViewIdChainExtractor *)idExtractor eventCollected:(EventCollectorBlock)eventCollectedBlock;

- (void) start;
- (void) stop;

@end
