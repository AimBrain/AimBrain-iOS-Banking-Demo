
#import "UIViewController+Visibility.h"


@implementation UIViewController (Visibility)

- (BOOL)isViewVisible {
    return self.isViewLoaded && self.view.window;
}

@end