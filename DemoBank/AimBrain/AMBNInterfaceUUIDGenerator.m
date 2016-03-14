#import "AMBNInterfaceUUIDGenerator.h"
#import <Foundation/Foundation.h>

#define AMBNInterfaceUUIDGeneratorVersionKey @"AMBNInterfaceUUIDGeneratorVersionKey"
#define AMBNInterfaceUUIDGeneratorUUIDKey @"AMBNInterfaceUUIDGeneratorUUIDKey"
#define AMBNInterfaceUUIDGeneratorCurrentVersion @"1"

@implementation AMBNInterfaceUUIDGenerator

+ (NSString *) getInterfaceUUID {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * currentStoredVersion = [defaults stringForKey:AMBNInterfaceUUIDGeneratorVersionKey];
    NSString * uuid = [defaults stringForKey:AMBNInterfaceUUIDGeneratorUUIDKey];
    if(uuid && [currentStoredVersion isEqualToString:AMBNInterfaceUUIDGeneratorCurrentVersion]){
        return uuid;
    }else{
        uuid = [self generateUUID];
        [defaults setObject:AMBNInterfaceUUIDGeneratorCurrentVersion forKey:AMBNInterfaceUUIDGeneratorVersionKey];
        [defaults setObject:uuid forKey:AMBNInterfaceUUIDGeneratorUUIDKey];
        [defaults synchronize];
        return uuid;
    }
}

+ (NSString *) generateUUID {
    return [[NSUUID UUID] UUIDString];
}

@end
