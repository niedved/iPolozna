//
//  BFCameraViewController.m
//  BetFairPOC
//  Copyright (c) 2012 ARFixer. All rights reserved.
//

#import "BFAudioViewController.h"
#import "BFResultsNavigationController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AudioToolbox/AudioServices.h>



@interface BFAudioViewController ()


@end

@implementation BFAudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    reseting = NO;
    playingSample = NO;
    recordTime = 0.0f;
    recordMaxTime = 15.0f;
        // Disable Stop/Play button when application launches
        [stopButton setEnabled:NO];
        [playButton setEnabled:NO];
        
        // Set the audio file
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"MyAudioMemo.m4a",
                                   nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        // Define the recorder setting
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
    
    [audioProgress setProgress:recordTime/recordMaxTime];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
    
    
  
    
    
}


-(void)checkRecState{
    NSLog(@"recorder state: %d", recorder.recording);
    if ( recorder.recording){
        recordTime+=0.25;
        [audioProgress setProgress:recordTime/recordMaxTime];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                   target:self
                                                 selector:@selector(checkRecState)
                                                 userInfo:nil
                                                  repeats:NO];
    }
    
}

- (void)viewDidUnload{
    [recordPauseButton release];
    recordPauseButton = nil;
    [stopButton release];
    stopButton = nil;
    [playButton release];
    playButton = nil;
    [audioProgress release];
    audioProgress = nil;
    [myTimer invalidate];
    myTimer = nil;
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (IBAction)recordPressed:(id)sender{
    NSLog(@"PRESSED");
    
    
    if (player.playing) {
        [player stop];
    }
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
//        [recorder record];
        [recorder recordForDuration:recordMaxTime];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                   target:self
                                                 selector:@selector(checkRecState)
                                                 userInfo:nil
                                                  repeats:NO];
        
    }
    
//    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
//    [recordPauseButton setBackgroundImage:[UIImage imageNamed:@"talk-now-pressed.png"] forState:UIControlStateNormal];
    
    
    
}
- (IBAction)recordUnPressed:(id)sender{
    
//    [recordPauseButton setBackgroundImage:[UIImage imageNamed:@"talk-now.png"] forState:UIControlStateNormal];
    NSLog(@"UNPRESSED");
    if (player.playing) {
        [player stop];
    }
    // Pause recording
    [recorder pause];
//    recorder 
    
    [playButton setEnabled:YES];
    
    
}

-(void) audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"audioRecorderBeginInterruption");
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    if ( reseting ){
        NSLog(@"audio reseting");
        recordTime = 0.0f;
        [audioProgress setProgress:recordTime/recordMaxTime];
        [recordPauseButton setEnabled:YES];
        reseting = NO;
    }
    else{
        NSLog(@"audio did finish recording");
        [audioProgress setProgress:1.00f];
        [recordPauseButton setEnabled:NO];
    }
    
    
    [playButton setEnabled:YES];
}


- (IBAction)clearTapped:(id)sender{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    reseting = YES;
    [recorder stop];
    
    
    
}

- (IBAction)playTapped:(id)sender {
    playingSample = YES;
    if (!recorder.recording){
        [recorder stop];
    
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Czy kontynuować?"
                                                    message: @"Czy pytanie brzmi poprawnie ? "
                                                   delegate: self
                                          cancelButtonTitle:@"Popraw"
                                          otherButtonTitles:@"Akceptuj",nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"popraw");
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        reseting = YES;
        [recorder stop];
        
    }
    else
    {
        NSLog(@"dalej");
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                                 bundle: nil];
        BFResultsNavigationController *controller = (BFResultsNavigationController*)[mainStoryboard
                                                                                     instantiateViewControllerWithIdentifier: @"podsumowanieViewController"];
        //[cameraPicker push:controller animated:YES];
//        [cameraPicker dismissModalViewControllerAnimated:YES];
        [self.navigationController pushViewController:controller animated:YES];
//        [picker release];
    }
}


- (void)dealloc {
    [recordPauseButton release];
    [stopButton release];
    [playButton release];
    [audioProgress release];
    [super dealloc];
}
@end
