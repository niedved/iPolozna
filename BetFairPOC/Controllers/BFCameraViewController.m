//
//  BFCameraViewController.m
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import "BFCameraViewController.h"
#import "BFResultsNavigationController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BFCameraViewController ()

@end

@implementation BFCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)showCamera:(id)sender{
    toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 480-55, 320, 55)] autorelease];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    NSArray *items = [NSArray arrayWithObjects:
                    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease],
                    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)] autorelease],
                    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                    nil];
    [toolBar setItems:items];
    
    // create the overlay view
    overlayView=[[[OverlayView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-44)] autorelease];
    // important - it needs to be transparent so the camera preview shows through!
    overlayView.opaque = NO;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // parent view for our overlay
    UIView *parentView=[[[UIView alloc] initWithFrame:CGRectMake(0,0,320, 480)] autorelease];
    [parentView addSubview:overlayView];
    [parentView addSubview:toolBar];
    
    // configure the image picker with our overlay view
    cameraPicker=[[UIImagePickerController alloc] init];
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraPicker.delegate = self;
    
    // hide the camera controls
    cameraPicker.showsCameraControls=NO;
    cameraPicker.wantsFullScreenLayout = YES;
    cameraPicker.cameraOverlayView = parentView;
    [self presentModalViewController:cameraPicker animated:YES];

}
- (void)cancel{
    [self dismissModalViewControllerAnimated:YES];
    [cameraPicker release];
}
- (void)takePhoto{
    [cameraPicker takePicture];
}
- (void)imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // imporatant: we don't save the photo in the camera roll after taking it
    // custom case: we get reference to viewController to present it on the camera view
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    BFResultsNavigationController *controller = (BFResultsNavigationController*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"resultsNavigationController"];
    //[cameraPicker push:controller animated:YES];
    [cameraPicker dismissModalViewControllerAnimated:YES];
    [self.navigationController pushViewController:controller animated:YES];
    [picker release];
    
    
}

@end
