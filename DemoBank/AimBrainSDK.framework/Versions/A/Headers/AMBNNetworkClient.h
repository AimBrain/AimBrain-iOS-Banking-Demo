//
// Created by Arunas on 18/07/16.
// Copyright (c) 2016 Paweł Kupiec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMBNSerializedRequest;

FOUNDATION_EXPORT NSString *const AMBNCreateSessionEndpoint;
FOUNDATION_EXPORT NSString *const AMBNSubmitBehaviouralEndpoint;
FOUNDATION_EXPORT NSString *const AMBNGetScoreEndpoint;
FOUNDATION_EXPORT NSString *const AMBNFacialEnrollEndpoint;
FOUNDATION_EXPORT NSString *const AMBNFacialEnrollWithoutSessionEndpoint;
FOUNDATION_EXPORT NSString *const AMBNFacialAuthEndpoint;
FOUNDATION_EXPORT NSString *const AMBNFacialAuthWithoutSessionEndpoint;
FOUNDATION_EXPORT NSString *const AMBNFacialCompareEndpoint;
FOUNDATION_EXPORT NSString *const AMBNVoiceEnrollEndpoint;
FOUNDATION_EXPORT NSString *const AMBNVoiceEnrollWithoutSessionEndpoint;
FOUNDATION_EXPORT NSString *const AMBNVoiceAuthEndpoint;
FOUNDATION_EXPORT NSString *const AMBNVoiceAuthWithoutSessionEndpoint;
FOUNDATION_EXPORT NSString *const AMBNVoiceTokenEndpoint;
FOUNDATION_EXPORT NSString *const AMBNVoiceTokenWithoutSessionEndpoint;

@interface AMBNNetworkClient : NSObject
- (instancetype)initWithApiKey:(NSString *)apiKey secret:(NSString *)secret;

- (instancetype)initWithApiKey:(NSString *)apiKey secret:(NSString *)secret baseUrl:(NSString *)baseUrl;

- (AMBNSerializedRequest *)serializeRequestData:(id)data;

- (NSMutableURLRequest *)createJSONPOSTWithData:(id)data endpoint:(NSString *)path;

- (void)sendRequest:(NSMutableURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(id _Nullable responseJSON, NSError *_Nullable connectionError))completion;
@end