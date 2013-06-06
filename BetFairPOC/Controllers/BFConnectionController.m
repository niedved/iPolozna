//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import "BFConnectionController.h"

@implementation BFConnectionController
@synthesize delegate;

static BFConnectionController *sharedSingleton;

+ (BFConnectionController *)sharedController{
    @synchronized(self){
        if (!sharedSingleton)
            sharedSingleton = [[BFConnectionController alloc] init];
        return sharedSingleton;
    }
}
- (id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
- (void)sendUserData:(BFUserData *)userData{
    NSString *URLString = [NSString stringWithFormat:@"http://tvguide.betfair.com/api/%@_GBR?tv_only=true&sport_id=1&time_from=%@&time_to=%@", userData.countryCode, userData.timeFrom, userData.timeTo];
    URLString = @"http://tvguide.betfair.com/api/en_GBR?tv_only=true&sport_id=1&time_from=2012-09-09+10:15:24&time_to=2012-09-12+00:00:00"; // TODO: change from fake
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:URL] autorelease];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [delegate dataReceived:data];
    }];
}
- (void)dealloc{
    delegate = nil;
    [super dealloc];
}
@end
