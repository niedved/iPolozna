//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import "BFUserData.h"

@implementation BFUserData

@synthesize location, timeTo, timeFrom, countryCode;

- (id)initWithLocation:(CLLocation *)newLocation countryCode:(NSString *)newCountryCode{
    self = [super init];
    if(self){
        self.location = newLocation;
        self.countryCode = newCountryCode;
    }
    return self;
}

- (NSString *)timeTo{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSString *dateWithTimeString = [NSString stringWithFormat:@"%@+00:00:00", dateString];
    [dateFormat release];
    return dateWithTimeString;
}

- (NSString *)timeFrom{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd+hh:mm:ss"];
    NSString *dateWithTimeString = [dateFormat stringFromDate:today];
    [dateFormat release];
    return dateWithTimeString;
}
- (void)dealloc{
    [location release];
    location = nil;
    [countryCode release];
    countryCode = nil;
    [timeTo release];
    timeTo = nil;
    [timeFrom release];
    timeFrom = nil;
    [super dealloc];
}

@end
