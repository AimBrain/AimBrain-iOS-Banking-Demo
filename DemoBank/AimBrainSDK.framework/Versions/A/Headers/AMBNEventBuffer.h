
#import <Foundation/Foundation.h>


@class AMBNBaseEvent;

/**
 Class is responsible for adding and removing event objects to buffer, counting buffer size used in memory and clearing old objects if needed
 */
@interface AMBNEventBuffer : NSObject

/**
 List of all events. Read only.
 */
@property (readonly) NSMutableArray<AMBNBaseEvent *> *buffer;

/**
 Approximate event size in bytes
 */
@property (readonly) NSInteger eventSizeInBytes;

/**
 Approximate buffer size in bytes
 */
@property (readonly) NSInteger bufferSizeInBytes;

/**
 Must to use `initWithEvetSize:` instead
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Initialization with average size of one event in bytes
 */
- (instancetype)initWithEventSize:(NSInteger)size NS_DESIGNATED_INITIALIZER;

/**
 Adds event object to buffer
 */
- (void)addObject:(id)object;

/**
 Removes all event objects from buffer
 */
- (void)removeAllObjects;

/**
 Insert all event objects from given array to buffer at index `0`
 */
- (void)addObjectsFromArray:(NSArray *)array;

/**
 Returns immutable copy of events buffer
 */
- (NSArray *)bufferCopy;

/**
 Returns timestamp of first object in buffer
 */
- (NSTimeInterval)oldestObjectTimestamp;

/**
 Deletes all objects with timestamp which is smaller or equal to given timestamp and returns size in bytes of cleared data
 */
- (NSInteger)clearObjectsOlderThanTimestamp:(NSTimeInterval)timestamp;

/**
 Returns size of all events with given range in bytes
 */
- (NSInteger)sizeOfEventsInRange:(NSRange)range;

@end
