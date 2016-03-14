#import <Foundation/Foundation.h>

#define AMBNErrorUnprocessableResponse 1001
#define AMBNErrorIncompleteResponse 1001
#define AMBNExampleAppErrorDomain @"com.aimbrain.demoapp.ErrorDomain"

@interface AMBNDemoServer : NSObject

+ (instancetype) sharedInstance;
- (void) registerEmail: (NSString *) email completion: (void (^)(NSURL * loginURL, NSError * error))completion;
- (void) login: (NSURL *) loginURL completion: (void (^)(NSString * userId, NSString * pin, NSError * error))completion;
@end
