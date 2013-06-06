//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFTVEvent : NSObject{
    NSString *name;
    NSDate *start_time;
    NSString *marketId;
    NSString *marketType;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *start_time;
@property (nonatomic, retain) NSString *marketId;
@property (nonatomic, retain) NSString *marketType;

@end
