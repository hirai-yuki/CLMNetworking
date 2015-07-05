// CLMNetworkingClient.h
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
#import <Bolts/Bolts.h>
#import "CLMFilter.h"
#import "CLMNetworkingResult.h"
#import "NSError+CLMNetworking.h"

typedef void (^CLMConstructingBodyWithBlock)(id <AFMultipartFormData> formData);

@interface CLMNetworkingClient : NSObject

@property (nonatomic, readonly) AFHTTPRequestOperationManager *manager;
@property (nonatomic, readonly) CLMFilter *filter;

#pragma mark - Initializer

- (instancetype)initWithManager:(AFHTTPRequestOperationManager *)manager;

#pragma mark - Public - GET

- (BFTask *)GET:(NSString *)URLString parameters:(id)parameters;

#pragma mark - Public - HEAD

- (BFTask *)HEAD:(NSString *)URLString parameters:(id)parameters;

#pragma mark - Public - POST

- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters;
- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block;

#pragma mark - Public - PUT

- (BFTask *)PUT:(NSString *)URLString parameters:(id)parameters;
- (BFTask *)PUT:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block;

#pragma mark - Public - PATCH

- (BFTask *)PATCH:(NSString *)URLString parameters:(id)parameters;
- (BFTask *)PATCH:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block;

#pragma mark - Public - DELETE

- (BFTask *)DELETE:(NSString *)URLString parameters:(id)parameters;

#pragma mark - Public

- (void)cancelAll;

- (BFTask *)requestTaskWithHTTPMethod:(NSString *)method
                            URLString:(NSString *)URLString
                           parameters:(id)parameters
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

@end
