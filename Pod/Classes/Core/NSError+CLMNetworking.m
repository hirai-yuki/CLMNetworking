// NSError+CLMNetworking.m
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

#import "NSError+CLMNetworking.h"

NSString * const CLMNetworkingErrorDomain = @"CLMNetworkingErrorDomain";
NSString * const CLMNetworkingErrorUserInfoKeyResponseObject = @"responseObject";
NSString * const CLMNetworkingErrorUserInfoKeyOriginalError = @"originalError";

static const NSInteger HTTPStatusCodeBadRequest          = 400;
static const NSInteger HTTPStatusCodeUnauthorized        = 401;
static const NSInteger HTTPStatusCodeForbidden           = 403;
static const NSInteger HTTPStatusCodeNotFound            = 404;
static const NSInteger HTTPStatusCodeConflict            = 409;
static const NSInteger HTTPStatusCodeGone                = 410;
static const NSInteger HTTPStatusCodeUnprocessableEntity = 422;
static const NSInteger HTTPStatusCodeInternalServerError = 500;
static const NSInteger HTTPStatusCodeServiceUnavailable  = 503;

@implementation NSError (CLMNetworking)

#pragma mark - Lifecycle

+ (NSError *)CLMNetworkingErrorWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)originalError
{
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    userInfo[CLMNetworkingErrorUserInfoKeyOriginalError] = originalError;

    if (operation.responseObject) {
        userInfo[CLMNetworkingErrorUserInfoKeyResponseObject] = operation.responseObject;
    }
    
    NSInteger statusCode = 0;
    
    if (operation.response) {
        statusCode = operation.response.statusCode;
    }
    
    NSInteger errorCode;
    
    if (originalError.domain == NSURLErrorDomain && originalError.code == NSURLErrorNotConnectedToInternet) {
        errorCode = CLMNetworkingErrorCodeNotConnectedToInternet;
    } else if (originalError.domain == NSURLErrorDomain && originalError.code == NSURLErrorTimedOut) {
        errorCode = CLMNetworkingErrorCodeTimedOut;
    } else if (originalError.domain == NSURLErrorDomain && originalError.code == NSURLErrorBadServerResponse) {
        errorCode = CLMNetworkingErrorCodeBadServerResponse;
    } else if (originalError.domain == NSURLErrorDomain && originalError.code == NSURLErrorCancelled) {
        errorCode = CLMNetworkingErrorCodeCancelled;
    } else if (statusCode == HTTPStatusCodeBadRequest) {
        errorCode = CLMNetworkingErrorCodeBadRequest;
    } else if (statusCode == HTTPStatusCodeUnauthorized) {
        errorCode = CLMNetworkingErrorCodeUnauthorized;
    } else if (statusCode == HTTPStatusCodeForbidden) {
        errorCode = CLMNetworkingErrorCodeForbidden;
    } else if (statusCode == HTTPStatusCodeNotFound) {
        errorCode = CLMNetworkingErrorCodeNotFound;
    } else if (statusCode == HTTPStatusCodeConflict) {
        errorCode = CLMNetworkingErrorCodeConflict;
    } else if (statusCode == HTTPStatusCodeGone) {
        errorCode = CLMNetworkingErrorCodeGone;
    } else if (statusCode == HTTPStatusCodeUnprocessableEntity) {
        errorCode = CLMNetworkingErrorCodeUnprocessableEntity;
    } else if (statusCode == HTTPStatusCodeInternalServerError) {
        errorCode = CLMNetworkingErrorCodeInternalServerError;
    } else if (statusCode == HTTPStatusCodeServiceUnavailable) {
        errorCode = CLMNetworkingErrorCodeServiceUnavailable;
    } else {
        errorCode = CLMNetworkingErrorCodeUndefined;
    }
    
    return [NSError CLMNetworkingErrorWithErrorCode:errorCode userInfo:userInfo];
}

+ (NSError *)CLMNetworkingErrorWithErrorCode:(CLMNetworkingErrorCode)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:CLMNetworkingErrorDomain
                               code:code
                           userInfo:userInfo];
}

#pragma mark - Public

- (id)responseObject
{
    return self.userInfo[CLMNetworkingErrorUserInfoKeyResponseObject];
}

- (BOOL)notConnectedToInternet
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeNotConnectedToInternet;
}

- (BOOL)timedOut
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeTimedOut;
}

- (BOOL)badServerResponse
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeBadServerResponse;
}

- (BOOL)cancelled
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeCancelled;
}

#pragma mark - Public - Status code 40x error

- (BOOL)badRequest
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeBadRequest;
}

- (BOOL)unauthorized
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeUnauthorized;
}

- (BOOL)forbidden
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeForbidden;
}

- (BOOL)notFound
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeNotFound;
}

- (BOOL)conflict
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeConflict;
}

- (BOOL)gone
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeGone;
}

- (BOOL)unprocessableEntity
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeUnprocessableEntity;
}

#pragma mark - Public - Status code 50x error

- (BOOL)internalServerError
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeInternalServerError;
}

- (BOOL)serviceUnavailable
{
    return self.domain == CLMNetworkingErrorDomain && self.code == CLMNetworkingErrorCodeServiceUnavailable;
}

@end
