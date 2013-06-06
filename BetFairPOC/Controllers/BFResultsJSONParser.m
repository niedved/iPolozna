//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import "BFResultsJSONParser.h"

@implementation BFResultsJSONParser
@synthesize tvEventItemsArray, delegate;

- (void)parse:(NSData *)data{
    NSError *error = nil;
    NSString *stringFromData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if ([stringFromData length] > 0){
        NSArray *result = [NSJSONSerialization
                                    JSONObjectWithData:data
                                    options:kNilOptions
                                    error:&error];
        if (error){
            [self showError:error];
            [delegate parsingDidFail];
        } else {
            tvEventItemsArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *item in result){
                BFTVEvent *event = [[[BFTVEvent alloc] init] autorelease];
                event.name = [item objectForKey:@"name"];
                event.start_time = [self dateFromString:[item objectForKey:@"start_time"]];
                event.marketId = [item objectForKey:@"start_time"]; // TODO: Need to change to the proper one!
                event.marketType = [item objectForKey:@"start_time"]; // TODO: Need to change to the proper one!
                [tvEventItemsArray addObject:event];
            }
            [delegate parsingDidEnd];
        }
    } else {
        [self showError:error];
        [delegate parsingDidFail];
    }
}
- (NSDate *)dateFromString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    
    NSDate *date = [dateFormatter dateFromString:str];
    [dateFormatter release];
    return date;
}
- (void)showError:(NSError *)error{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error retrieving events list"
                                                    message:[error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil] autorelease];
    [alert show];
}
- (NSArray *)liveTVEvents{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    for(BFTVEvent *event in tvEventItemsArray){
        if([[NSDate date] timeIntervalSinceDate:event.start_time]>=0){
            [result addObject:event];
        }
    }
    return result;
}
- (NSArray *)comingSoonTVEvents{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    for(BFTVEvent *event in tvEventItemsArray){
        if([[NSDate date] timeIntervalSinceDate:event.start_time]<0){
            [result addObject:event];
        }
    }
    return result;
}
- (void)dealloc{
    [tvEventItemsArray release];
    tvEventItemsArray = nil;
    [super dealloc];
}
@end
