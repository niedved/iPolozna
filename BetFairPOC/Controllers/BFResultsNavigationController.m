//
//  BFResultsViewController.m
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import "BFResultsNavigationController.h"

@interface BFResultsNavigationController ()

@end

@implementation BFResultsNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed: @"navbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor colorWithRed:.25 green:.3 blue:.35 alpha:1];
}
- (void)viewDidUnload{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
