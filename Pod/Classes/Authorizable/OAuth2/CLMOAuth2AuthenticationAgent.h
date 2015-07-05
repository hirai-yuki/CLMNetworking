// CLMOAuth2AuthenticationAgent.h
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
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import "CLMAuthorizableNetworkingClient.h"

@protocol CLMOAuth2CredentialProvider;

@interface CLMOAuth2AuthenticationAgent : NSObject <CLMAuthenticationAgent>

@property (nonatomic, readonly) AFOAuth2Manager *manager;
@property (nonatomic, readonly) NSString *endpoint;
@property (nonatomic, readonly) id<CLMOAuth2CredentialProvider> credentialProvider;

#pragma mark - Initializer

+ (instancetype)authenticationAgentWithBaseURL:(NSURL *)url
                                      endpoint:(NSString *)endpoint
                                      clientID:(NSString *)clientID
                                        secret:(NSString *)secret
                            credentialProvider:(id<CLMOAuth2CredentialProvider>)credentialProvider;

- (instancetype)initWithOAuth2Manager:(AFOAuth2Manager *)manager
                   credentialProvider:(id<CLMOAuth2CredentialProvider>)credentialProvider
                             endpoint:(NSString *)endpoint;

#pragma mark - Public

- (BFTask *)authenticateUsingOAuthWithUsername:(NSString *)username
                                      password:(NSString *)password
                                         scope:(NSString *)scope;


- (BFTask *)authenticateUsingOAuthWithScope:(NSString *)scope;


- (BFTask *)authenticateUsingOAuthWithRefreshToken:(NSString *)refreshToken;


- (BFTask *)authenticateUsingOAuthWithCode:(NSString *)code
                               redirectURI:(NSString *)uri;


- (BFTask *)authenticateUsingOAuthParameters:(NSDictionary *)parameters;

@end

#pragma mark -

@protocol CLMOAuth2CredentialProvider <NSObject>

@required

- (AFOAuthCredential *)OAuth2Credential;
- (void)setOAuth2Credential:(AFOAuthCredential *)OAuth2Credential;

@end
