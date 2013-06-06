//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol BFLocationControllerDelegate
@required
- (void)locationFound:(CLLocation *)location withCountryCode:(NSString *)countryCode;
@end

@interface BFLocationController : NSObject <CLLocationManagerDelegate>{
    NSObject <BFLocationControllerDelegate> *delegate;
}

@property (nonatomic, assign) NSObject <BFLocationControllerDelegate> *delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLGeocoder *geoCoder;

- (void)findLocation;

@end
