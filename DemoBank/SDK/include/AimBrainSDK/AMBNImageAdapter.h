#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMBNImageAdapter : NSObject
@property CGFloat jpegQuality;
@property NSInteger maxHeight;

- (id) initWithQuality: (CGFloat) quality maxHeight: (NSInteger) maxHeight;
- (NSString *) encodedImage:(UIImage *)image;

@end
