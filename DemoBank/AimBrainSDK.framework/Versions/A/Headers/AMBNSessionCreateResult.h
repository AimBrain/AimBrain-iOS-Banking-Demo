//
// Created by Arunas on 10/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBNCallResult.h"


@interface AMBNSessionCreateResult : AMBNCallResult

@property(nonatomic, strong, readonly) NSNumber *face;

@property(nonatomic, strong, readonly) NSNumber *voice;

@property(nonatomic, strong, readonly) NSNumber *behaviour;

@property(nonatomic, strong, readonly) NSString *session;

- (instancetype)initWithFace:(NSNumber *)face voice:(NSNumber *)voice behaviour:(NSNumber *)behaviour session:(NSString *)session metadata:(NSData *)metadata;

@end
