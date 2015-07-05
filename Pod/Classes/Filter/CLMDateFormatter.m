// CLMDateFormatter.m
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

#import "CLMDateFormatter.h"

@implementation CLMDateFormatter

#pragma mark - Public

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format
{
    if (!dateString || dateString.length == 0) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    if (!date) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = format;
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    return [dateFormatter stringFromDate:date];
}

@end
