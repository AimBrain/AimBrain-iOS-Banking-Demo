//
// Created by Arunas on 10/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBNCallResult.h"


@interface AMBNCompareFaceResult : AMBNCallResult
@property(nonatomic, strong, readonly) NSNumber *similarity;
@property(nonatomic, strong, readonly) NSNumber *firstLiveliness;
@property(nonatomic, strong, readonly) NSNumber *secondLiveliness;
- (instancetype)initWithSimilarity:(NSNumber *)score firstLiveliness:(NSNumber *)firstLiveliness secondLiveliness:(NSNumber *)secondLiveliness metadata:(NSData *)metadata;
@end