// CLMAuthorizableNetworkingClient.h
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

#import "CLMNetworkingClient.h"

@protocol CLMAuthenticationAgent;

@interface CLMAuthorizableNetworkingClient : NSObject

@property (nonatomic, readonly) CLMNetworkingClient *networkingClient;
@property (nonatomic, readonly) id<CLMAuthenticationAgent> authenticationAgent;

#pragma mark - Initializer

- (instancetype)initWithNetworkingClient:(CLMNetworkingClient *)networkingClient
                     authenticationAgent:(id<CLMAuthenticationAgent>)authenticationAgent;

#pragma mark - Public - GET

- (BFTask *)GET:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - HEAD

- (BFTask *)HEAD:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - POST

- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication;
- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - PUT

- (BFTask *)PUT:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication;
- (BFTask *)PUT:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - PATCH

- (BFTask *)PATCH:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - DELETE

- (BFTask *)DELETE:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public

- (void)cancelAll;

@end

#pragma mark - CLMAuthenticationAgent protocol

@protocol CLMAuthenticationAgent <NSObject>

@required
- (void)setCredential:(AFHTTPRequestOperationManager *)manager;
- (BFTask *)refreshCredential;
- (BOOL)hasCredential;
- (BOOL)isExpiredCredential;

@end
