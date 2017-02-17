//
// Created by Arunas on 10/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBNCallResult.h"


@interface AMBNAuthenticateResult : AMBNCallResult

@property(nonatomic, strong, readonly) NSNumber *score;

@property(nonatomic, strong, readonly) NSNumber *liveliness;

- (instancetype)initWithScore:(NSNumber *)score liveliness:(NSNumber *)liveliness metadata:(NSData *)metadata;

@end