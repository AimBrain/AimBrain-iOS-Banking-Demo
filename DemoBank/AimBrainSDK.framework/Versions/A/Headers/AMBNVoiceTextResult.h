//
// Created by Arunas on 10/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBNCallResult.h"

@interface AMBNVoiceTextResult : AMBNCallResult

@property(nonatomic, readonly) NSString *tokenText;

- (instancetype)initWithTokenText:(NSString *)text metadata:(NSData *)metadata;

@end