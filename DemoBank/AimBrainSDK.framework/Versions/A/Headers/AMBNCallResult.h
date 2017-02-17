//
// Created by Arunas on 10/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
  @discussion Base class for API call result values.
 */
@interface AMBNCallResult : NSObject

/*!
  @discussion Response metadata
 */
@property(nonatomic, strong, readonly) NSData *metadata;

/*!
  @discussion Response metadata as utf-8 encoded string
 */
@property(nonatomic, strong, readonly) NSString *metadataString;

/*!
  @discussion Init value object
  @param metadata Metadata field
 */
- (instancetype) initWithMetadata: (NSData *) metadata NS_DESIGNATED_INITIALIZER;

@end