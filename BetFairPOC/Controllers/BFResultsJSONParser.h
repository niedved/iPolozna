//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTVEvent.h"

@protocol BFResultsJSONParserDelegate <NSObject>

- (void)parsingDidEnd;
- (void)parsingDidFail;

@end

@interface BFResultsJSONParser : NSObject{
    NSMutableArray *tvEventItemsArray;
    NSObject<BFResultsJSONParserDelegate> *delegate;
}
@property (nonatomic, retain) NSMutableArray *tvEventItemsArray;
@property (nonatomic, assign) NSObject<BFResultsJSONParserDelegate> *delegate;

- (NSArray *)liveTVEvents;
- (NSArray *)comingSoonTVEvents;

- (void)parse:(NSData *)data;
@end
