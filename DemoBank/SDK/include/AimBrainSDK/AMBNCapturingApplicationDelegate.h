#import <Foundation/Foundation.h>

@protocol AMBNCapturingApplicationDelegate <NSObject>

-(void)capturingApplication: (id) application event: (UIEvent *) event;

@end