//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import "BFResultsViewController.h"

@interface BFResultsViewController ()

@end

@implementation BFResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)dealloc{
    [locationController release];
    locationController = nil;
    [super dealloc];
}
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [activityIndicatorView startAnimating];
    tableView.hidden = YES;
    locationController = [[BFLocationController alloc] init];
    locationController.delegate = self;
    [locationController findLocation];
}
- (IBAction)backToCamera:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    BFCameraViewController *controller = (BFCameraViewController*)[mainStoryboard
                                                                   instantiateViewControllerWithIdentifier: @"cameraViewController"];
    [self presentModalViewController:controller animated:YES];
    [controller showCamera:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark BFLocationControllerDelegate methods
- (void)locationFound:(CLLocation *)location withCountryCode:(NSString *)countryCode{
    // Displaying user data
    BFUserData *userData = [[BFUserData alloc] initWithLocation:location countryCode:countryCode];
    
    // Saving user data
    [[BFConnectionController sharedController] sendUserData:userData];
    [[BFConnectionController sharedController] setDelegate:self];
    [userData release];
}

#pragma mark -
#pragma mark BFConnectionControllerDelegate methods
- (void)dataReceived:(NSData *)data{
    [jsonParser release];
    jsonParser = [[BFResultsJSONParser alloc] init];
    jsonParser.delegate = self;
    [jsonParser parse:data];
}

#pragma mark -
#pragma mark BFResultsJSONParserDelegate methods
- (void)parsingDidEnd{
    tableView.hidden = NO;
    [tableView reloadData];
}
- (void)parsingDidFail{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    BFCameraViewController *controller = (BFCameraViewController*)[mainStoryboard
                                                                                 instantiateViewControllerWithIdentifier: @"cameraViewController"];
    [self presentModalViewController:controller animated:YES];
}
#pragma mark -
#pragma mark UITableViewDataSource methods
- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return [jsonParser tvEventItemsArray]?2:0;
}
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [jsonParser liveTVEvents].count==0?1:[jsonParser liveTVEvents].count;
    } else {
        return [jsonParser comingSoonTVEvents].count==0?1:[jsonParser comingSoonTVEvents].count;
    }
}
- (BFTVEvent *)eventForIndexPath:(NSIndexPath *)indexPath{
    BFTVEvent *event = nil;
    if(indexPath.section == 0){
        if([jsonParser liveTVEvents].count>0)
            event = [[jsonParser liveTVEvents] objectAtIndex:indexPath.row];
    } else {
        if([jsonParser comingSoonTVEvents].count>0)
            event = [[jsonParser comingSoonTVEvents] objectAtIndex:indexPath.row];
    }
    return event;
}
- (UITableViewCell *)tableView:(UITableView *)tabView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    UIColor *lightBackground = [UIColor colorWithRed:(float)255/255 green:(float)255/255 blue:(float)255/255 alpha:(float)1];
    UIColor *darkBackground = [UIColor colorWithRed:(float)239/255 green:(float)242/255 blue:(float)242/255 alpha:(float)1];
    cell.backgroundColor = indexPath.row % 2 == 0 ? lightBackground : darkBackground;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    BFTVEvent *event = [self eventForIndexPath:indexPath];
    if(event){
        NSArray *eventNameParts = [event.name componentsSeparatedByString:@"- "];
        if (eventNameParts.count > 0){
            NSString *teams = [eventNameParts objectAtIndex:2];
            NSString *eventKind = [eventNameParts objectAtIndex:0];
            cell.detailTextLabel.text = eventKind;
            cell.textLabel.text = teams;
        } else {
            cell.textLabel.text = event.name;
            cell.detailTextLabel.text = @"No details";
        }
    }
    else
        cell.textLabel.text = @"No events found!";
    return cell;
}
- (void)tableView:(UITableView *)tabView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tabView deselectRowAtIndexPath:indexPath animated:YES];
    BFTVEvent *event = [self eventForIndexPath:indexPath];
    NSURL *bfURL = [NSURL URLWithString:[NSString stringWithFormat:@"bfsportsbetting://openMarket?marketId=%@&marketType=%@", event.marketId, event.marketType]];
    [[UIApplication sharedApplication] openURL:bfURL];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section==0?@"Live events":@"Coming soon";
}

@end
