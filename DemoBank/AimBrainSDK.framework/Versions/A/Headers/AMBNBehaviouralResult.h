//
// Created by Arunas on 10/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBNCallResult.h"


@interface AMBNBehaviouralResult : AMBNCallResult

/*!
 @discussion Score is value between 0 and 1.
 */
@property(nonatomic, strong, readonly) NSNumber *score;

/*!
 @discussion Behavioral analysis engine learning status.
 */
@property(nonatomic, readonly) NSInteger status;

/*!
 @discussion Session.
 */
@property(nonatomic, strong, readonly) NSString *session;

- (instancetype)initWithScore:(NSNumber *)score status:(NSInteger)status session:(NSString *)session metadata:(NSData *)metadata;

@end