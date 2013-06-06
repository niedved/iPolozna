//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BFUserData.h"

@protocol BFConnectionControllerDelegate <NSObject>

- (void)dataReceived:(NSData *)data;

@end

@interface BFConnectionController : NSObject{
    NSObject<BFConnectionControllerDelegate> *delegate;
}
@property (nonatomic, assign) NSObject<BFConnectionControllerDelegate> *delegate;

+ (BFConnectionController *)sharedController;
- (void)sendUserData:(BFUserData *)userData;

@end
