//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BFUserData : NSObject{
    NSString *timeTo;
    NSString *timeFrom;
    NSString *countryCode;
    CLLocation *location;
}

@property (nonatomic, retain) NSString *timeTo;
@property (nonatomic, retain) NSString *timeFrom;
@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, retain) CLLocation *location;

- (id)initWithLocation:(CLLocation *)newLocation countryCode:(NSString *)countryCode;

@end
