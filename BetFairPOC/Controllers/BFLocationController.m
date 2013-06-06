//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import "BFLocationController.h"

@interface BFLocationController ()

@end

@implementation BFLocationController

@synthesize delegate, locationManager, currentLocation, geoCoder;

- (void)findLocation{
    geoCoder = [[CLGeocoder alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.currentLocation = newLocation;
    
    if(newLocation.horizontalAccuracy <= 100.0f) {
        [locationManager stopUpdatingLocation];
        [self geoCodeLocation:newLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == kCLErrorDenied){
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown){
        // retry
    } else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] autorelease];
        [alert show];
    }
}
- (void)geoCodeLocation:(CLLocation *)location{
    //Geocoding Block
    [geoCoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error){
         //Get nearby address and get ISO country code - if gb, replace it with en
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *countryCode = [placemark.ISOcountryCode lowercaseString];
         countryCode = @"gb"; // TODO: remove if don't want fake country
         if ([countryCode isEqualToString:@"gb"]) countryCode = @"en";
         if (delegate) [delegate locationFound:location withCountryCode:countryCode];
     }];
}
- (void)dealloc{
    [geoCoder release];
    geoCoder = nil;
    [locationManager release];
    locationManager = nil;
    delegate = nil;
    [super dealloc];
}
@end
