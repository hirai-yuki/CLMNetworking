// CLMRESTAPICoordinator.m
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

#import "CLMRESTAPICoordinator.h"
#import "CLMAuthorizableNetworkingClient.h"
#import "CLMNullFilterHandler.h"
#import "CLMDateFilterHandler.h"
#import "CLMURLFilterHandler.h"

@implementation CLMRESTAPICoordinator

#pragma mark - Initializer

+ (instancetype)coordinatorWithBaseURL:(NSURL *)url
                   OAuth2TokenEndpoint:(NSString *)OAuth2TokenEndpoint
                              clientID:(NSString *)clientID
                                secret:(NSString *)secret
                    credentialProvider:(id<CLMOAuth2CredentialProvider>)credentialProvider
{
    CLMOAuth2AuthenticationAgent *OAuth2Client = [CLMOAuth2AuthenticationAgent authenticationAgentWithBaseURL:url
                                                                                                     endpoint:OAuth2TokenEndpoint
                                                                                                     clientID:clientID
                                                                                                       secret:secret
                                                                                           credentialProvider:credentialProvider];
    
    return [[self alloc] initWithBaseURL:url
                     authenticationAgent:OAuth2Client];
}

- (instancetype)initWithBaseURL:(NSURL *)url
            authenticationAgent:(CLMOAuth2AuthenticationAgent *)authenticationAgent
{
    NSParameterAssert(url);
    
    self = [super init];
    
    if (self) {
        _baseURL = url;
        _authenticationAgent = authenticationAgent;
    }
    
    return self;
}

#pragma mark - Public

- (CLMRESTAPIClient *)RESTAPIClientWithEndpoint:(NSString *)endpoint {
    NSParameterAssert(endpoint);
    
    AFHTTPRequestOperationManager *HTTPRequestOperationManager = [self HTTPRequestOperationManager];
    CLMNetworkingClient *newtworkingClient = [self networkingClientWithHTTPRequestOperationManager:HTTPRequestOperationManager];
    CLMAuthorizableNetworkingClient *authorizableNetworkingClient = [self authorizableNetworkingClientWithNetworkingClient:newtworkingClient];
    
    return [[CLMRESTAPIClient alloc] initWithAuthorizableNetworkingClient:authorizableNetworkingClient endpoint:endpoint];
}

#pragma mark - Private

- (AFHTTPRequestOperationManager *)HTTPRequestOperationManager
{
    return [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
}

- (CLMNetworkingClient *)networkingClientWithHTTPRequestOperationManager:(AFHTTPRequestOperationManager *)HTTPRequestOperationManager
{
    CLMNetworkingClient *networkingClient = [[CLMNetworkingClient alloc] initWithManager:HTTPRequestOperationManager];
    
    networkingClient.filter.handler = [self filterHandler];
    
    return networkingClient;
}

- (CLMAuthorizableNetworkingClient *)authorizableNetworkingClientWithNetworkingClient:(CLMNetworkingClient *)networkingClient
{
    return [[CLMAuthorizableNetworkingClient alloc] initWithNetworkingClient:networkingClient
                                                         authenticationAgent:self.authenticationAgent];
}

- (CLMFilterHandler *)filterHandler
{
    CLMNullFilterHandler *nullFilterHandler = [CLMNullFilterHandler defaultFilterHandler];
    CLMDateFilterHandler *dateFilterHandler = [CLMDateFilterHandler defaultFilterHandler];
    CLMURLFilterHandler *URLFilterHandler = [CLMURLFilterHandler  defaultFilterHandler];
    
    nullFilterHandler.nextHanlder = dateFilterHandler;
    dateFilterHandler.nextHanlder = URLFilterHandler;
    
    return nullFilterHandler;
}

@end
