// NSError+CLMNetworking.h
//
// Copyright (c) 2015 CLMNetworking (http://dev.classmethod.jp)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

extern NSString * const CLMNetworkingErrorDomain;
extern NSString * const CLMNetworkingErrorUserInfoKeyResponseObject;
extern NSString * const CLMNetworkingErrorUserInfoKeyOriginalError;

typedef NS_ENUM(NSInteger, CLMNetworkingErrorCode) {
    CLMNetworkingErrorCodeUndefined              = 0,
    CLMNetworkingErrorCodeNotConnectedToInternet = -1,
    CLMNetworkingErrorCodeTimedOut               = -2,
    CLMNetworkingErrorCodeBadServerResponse      = -3,
    CLMNetworkingErrorCodeCancelled              = -4,
    CLMNetworkingErrorCodeBadRequest             = -400,
    CLMNetworkingErrorCodeUnauthorized           = -401,
    CLMNetworkingErrorCodeForbidden              = -403,
    CLMNetworkingErrorCodeNotFound               = -404,
    CLMNetworkingErrorCodeConflict               = -409,
    CLMNetworkingErrorCodeGone                   = -410,
    CLMNetworkingErrorCodeUnprocessableEntity    = -422,
    CLMNetworkingErrorCodeInternalServerError    = -500,
    CLMNetworkingErrorCodeServiceUnavailable     = -503
};

@interface NSError (CLMNetworking)

#pragma mark - Initializer

+ (NSError *)CLMNetworkingErrorWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)originalError;

+ (NSError *)CLMNetworkingErrorWithErrorCode:(CLMNetworkingErrorCode)code userInfo:(NSDictionary *)userInfo;

#pragma mark - Public

- (id)responseObject;
- (BOOL)notConnectedToInternet;
- (BOOL)timedOut;
- (BOOL)badServerResponse;
- (BOOL)cancelled;

#pragma mark - Public - Status code 40x error

- (BOOL)badRequest;
- (BOOL)unauthorized;
- (BOOL)forbidden;
- (BOOL)notFound;
- (BOOL)conflict;
- (BOOL)gone;
- (BOOL)unprocessableEntity;

#pragma mark - Public - Status code 50x error

- (BOOL)internalServerError;
- (BOOL)serviceUnavailable;

@end
