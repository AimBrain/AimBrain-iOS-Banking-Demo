//
// Created by Arunas on 10/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBNCallResult.h"

@interface AMBNEnrollVoiceResult : AMBNCallResult

@property(nonatomic, readonly) bool success;
@property(nonatomic, strong, readonly) NSNumber *samplesCount;

- (instancetype)initWithSuccess:(bool)success samplesCount:(NSNumber *)samplesCount metadata:(NSData *)metadata;

@end