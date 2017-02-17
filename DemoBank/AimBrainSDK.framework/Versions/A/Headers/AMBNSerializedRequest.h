//
// Created by Arunas on 21/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMBNSerializedRequest : NSObject
@property (nonatomic, readonly, strong) NSData *data;
@property (nonatomic, readonly, strong) NSString *dataString;

- (instancetype)initWithData:(NSData *)data;
@end