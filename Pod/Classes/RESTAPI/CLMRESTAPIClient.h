// CLMRESTAPIClient.h
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
#import "CLMAuthorizableNetworkingClient.h"
#import "CLMResourcesResponse.h"

extern NSString * const CLMRESTAPIClientRequestParameterKeyPage;
extern NSString * const CLMRESTAPIClientRequestParameterKeyPerPage;
extern NSString * const CLMRESTAPIClientRequestParameterKeyFields;

@interface CLMRESTAPIClient : NSObject

@property (nonatomic) CLMAuthorizableNetworkingClient *authorizableNetworkingClient;
@property (nonatomic) NSString *endpoint;

#pragma mark - Initializer

- (instancetype)initWithAuthorizableNetworkingClient:(CLMAuthorizableNetworkingClient *)authorizableNetworkingClient
                                            endpoint:(NSString *)endpoint;

#pragma mark - Public - Read resources

- (BFTask *)getResourcesWithParameters:(NSDictionary *)parameters
                   needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)getResourcesWithParameters:(NSDictionary *)parameters
                                fields:(NSArray *)fields
                   needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - Read resource

- (BFTask *)getResourceWithIdentifier:(NSInteger)identifier
                           parameters:(NSDictionary *)parameters
                  needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)getResourceWithIdentifier:(NSInteger)identifier
                           parameters:(NSDictionary *)parameters
                               fields:(NSArray *)fields
                  needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)getResourceWithParameters:(NSDictionary *)parameters
                  needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)getResourceWithParameters:(NSDictionary *)parameters
                               fields:(NSArray *)fields
                  needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - Create resource

- (BFTask *)createResourceWithParameters:(NSDictionary *)parameters
                     needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)createResourceWithParameters:(NSDictionary *)parameters
               constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
                     needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - Update resource

- (BFTask *)updateResourceWithIdentifier:(NSInteger)identifier
                              parameters:(NSDictionary *)parameters
                     needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)updateResourceWithParameters:(NSDictionary *)parameters
                     needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)updateResourceWithIdentifier:(NSInteger)identifier
                              parameters:(NSDictionary *)parameters
               constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
                     needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)updateResourceWithParameters:(NSDictionary *)parameters
               constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
                     needsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public - Destroy resource

- (BFTask *)destroyResourceWithIdentifier:(NSInteger)identifier
                      needsAuthentication:(BOOL)needsAuthentication;

- (BFTask *)destroyResourceWithNeedsAuthentication:(BOOL)needsAuthentication;

#pragma mark - Public

- (void)cancelAll;

@end
