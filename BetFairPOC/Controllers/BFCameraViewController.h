//
//  BFCameraViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"

@interface BFCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *cameraPicker;
    IBOutlet UIButton *cameraButton;
    UIToolbar *toolBar;
    OverlayView *overlayView;
}

- (IBAction)showCamera:(id)sender;

@end
