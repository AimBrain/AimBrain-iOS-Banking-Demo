//
// Created by Arunas on 10/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBNCallResult.h"

@interface AMBNEnrollFaceResult : AMBNCallResult

@property(nonatomic, readonly) bool success;
@property(nonatomic, strong, readonly) NSNumber *imagesCount;

- (instancetype)initWithSuccess:(bool)success imagesCount:(NSNumber *)imagesCount metadata:(NSData *)metadata;

@end