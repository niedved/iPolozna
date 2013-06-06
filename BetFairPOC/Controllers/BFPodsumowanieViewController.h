//
//  BFAudioViewController.h
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import <AVFoundation/AVFoundation.h>


@interface BFPodsumowanieViewController : UIViewController < AVAudioRecorderDelegate, AVAudioPlayerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{
//    UIImagePickerController *cameraPicker;
    IBOutlet UIButton *cameraButton;
    UIToolbar *toolBar;
    OverlayView *overlayView;
    
    IBOutlet UIProgressView *audioProgress;
    IBOutlet UIButton *playButton;
    IBOutlet NSLayoutConstraint *stopButton;
    IBOutlet UIButton *recordPauseButton;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    NSTimer* myTimer;
    float recordTime, recordMaxTime;
    Boolean reseting, playingSample;
}


@end
