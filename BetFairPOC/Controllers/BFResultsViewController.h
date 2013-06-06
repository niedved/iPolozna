//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFUserData.h"
#import "BFConnectionController.h"
#import "BFLocationController.h"
#import "BFResultsJSONParser.h"
#import "BFCameraViewController.h"

@interface BFResultsViewController : UIViewController <BFLocationControllerDelegate, BFConnectionControllerDelegate, UITableViewDataSource, BFResultsJSONParserDelegate, UITableViewDelegate>{
    IBOutlet UITableView *tableView;
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
    BFResultsJSONParser *jsonParser;
    BFLocationController *locationController;
}

- (IBAction)backToCamera:(id)sender;

@end
