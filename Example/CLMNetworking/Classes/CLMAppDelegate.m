//
//  CLMAppDelegate.m
//  CLMNetworking
//
//  Created by CocoaPods on 02/12/2015.
//  Copyright (c) 2014 hirai.yuki. All rights reserved.
//

#import "CLMAppDelegate.h"
#import "CLMArticleService.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@implementation CLMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupStub];
    return YES;
}

#pragma mark - Private - Set up stub data

- (void)setupStub {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://localhost:3000/articles"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *fixture = OHPathForFile(@"articles.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
}

@end
