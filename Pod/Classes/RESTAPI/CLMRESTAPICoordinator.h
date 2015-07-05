// CLMRESTAPICoordinator.h
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

#import "CLMRESTAPIClient.h"
#import "CLMOAuth2AuthenticationAgent.h"
#import "CLMFilter.h"
#import <AFNetworking/AFNetworking.h>

@interface CLMRESTAPICoordinator : NSObject

@property (nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, readonly) CLMOAuth2AuthenticationAgent *authenticationAgent;

#pragma mark - Initializer

+ (instancetype)coordinatorWithBaseURL:(NSURL *)url
                   OAuth2TokenEndpoint:(NSString *)OAuth2TokenEndpoint
                              clientID:(NSString *)clientID
                                secret:(NSString *)secret
                    credentialProvider:(id<CLMOAuth2CredentialProvider>)credentialProvider;

- (instancetype)initWithBaseURL:(NSURL *)url
            authenticationAgent:(CLMOAuth2AuthenticationAgent *)authenticationAgent;

#pragma mark - Public

- (CLMRESTAPIClient *)RESTAPIClientWithEndpoint:(NSString *)endpoint;

@end
