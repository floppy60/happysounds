//
//  PlayerViewController.m
//  GeneratingSounds
//
//  Created by admin on 03/05/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "PlayerViewController.h"
#import "NSString+TimeToString.h"
#import "AllSoundsViewController.h"
#import "LightingRoundViewController.h"
#import "AppDelegate.h"

@interface PlayerViewController ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UILabel *trackCurrentPlaybackTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLengthLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;


@property (strong, nonatomic) NSTimer *timer;
@property BOOL panningProgress;
@property BOOL panningVolume;
@property BOOL isPaused;

@property (nonatomic, assign) BOOL repeatAll;
@property (nonatomic, assign) BOOL repeatOne;
@property (nonatomic, assign) BOOL shuffle;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"sfsdfs %@", self.query);
    
    seconds = 0;
//    self.countDownLabel.text = [NSString stringWithFormat:@"%li",(long)seconds];
    self.countDownLabel.text = @"";
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/%@",
                               [[NSBundle mainBundle] resourcePath], [self.query objectAtIndex:self.selectedIndex]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                                   error:nil];
    self.audioPlayer.delegate = self;
//    self.audioPlayer.numberOfLoops = -1; //Infinite
    
    [self.audioPlayer play];
    
    self.progressSlider.maximumValue = [self.audioPlayer duration];
    self.trackCurrentPlaybackTimeLabel.text = @"0:00";
    
    self.trackLengthLabel.text = [NSString stringWithFormat:@"-%@",
                          [self timeFormat:[self.audioPlayer duration]]];
    self.songLabel.text = [[self.query objectAtIndex:self.selectedIndex] stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
//    [self.view bringSubviewToFront:self.chooseView];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    timer = [[MZTimerLabel alloc] initWithLabel:self.lblTimer andTimerType:MZTimerLabelTypeStopWatch];
    timer.delegate = self;
    timer.timeFormat = @"ss";
    [timer setCountDownTime:appDelegate.currentTime];
    [timer start];
    [self.btnStartPause setTitle:@"Pause" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)startOrResumeStopwatch:(id)sender {
    
    if([timer counting]){
        [timer pause];
        [self.btnStartPause setTitle:@"Resume" forState:UIControlStateNormal];
    }else{
        [timer start];
        
        [self.btnStartPause setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)resetStopWatch:(id)sender {
    [timer reset];
    
    if(![timer counting]){
        [self.btnStartPause setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void)timerLabel:(MZTimerLabel *)timerlabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType{
    
    if([timerlabel isEqual:timer] && time > 60){
//        timerlabel.timeLabel.textColor = [UIColor redColor];
        [timer pause];
        [timer reset];
        if(![timer counting]){
            [self.btnStartPause setTitle:@"Start" forState:UIControlStateNormal];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Bell-ding" ofType:@"mp3"];
            
            NSURL *file = [[NSURL alloc] initFileURLWithPath:path];
            
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
            [self.player prepareToPlay];
            [self.player play];
        }
    }
    
}

- (IBAction)playButtonPressed {
    if (!self.isPaused) {
        [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"Controls_Play.png"] forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer pause];
        self.isPaused = TRUE;
    } else {
        
        seconds = 0;
//        self.countDownLabel.text = [NSString stringWithFormat:@"%li",(long)seconds];
        self.countDownLabel.text = @"";
        [countTimer invalidate];
        
        [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"Controls_Pause.png"]
                                   forState:UIControlStateNormal];
        if (self.repeatAll || self.repeatOne || self.shuffle)
            self.audioPlayer.delegate = self;
        
        [self.audioPlayer play];
        self.isPaused = FALSE;

    }
    
}

- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.panningProgress) {
        self.progressSlider.value = [self.audioPlayer currentTime];
    }
    self.trackCurrentPlaybackTimeLabel.text = [NSString stringWithFormat:@"%@",
                             [self timeFormat:[self.audioPlayer currentTime]]];
    
    self.trackLengthLabel.text = [NSString stringWithFormat:@"-%@",
                          [self timeFormat:[self.audioPlayer duration] - [self.audioPlayer currentTime]]];
    
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"sdsfsf %ld", (long)appDelegate.currentTime);
    appDelegate.currentTime++;
    
}

-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}


- (IBAction)prevButtonPressed {
    if (self.selectedIndex == 0)
        return;
    
    seconds = 0;
//    self.countDownLabel.text = [NSString stringWithFormat:@"%li",(long)seconds];
    self.countDownLabel.text = @"";
    [countTimer invalidate];
    
    NSUInteger newIndex = self.selectedIndex - 1;
    self.selectedIndex = newIndex;
    
    NSError *error = nil;
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/%@",
                               [[NSBundle mainBundle] resourcePath], [self.query objectAtIndex:self.selectedIndex]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    AVAudioPlayer *newAudioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    
    self.audioPlayer = newAudioPlayer;
    [self.audioPlayer play];
    
    if (error)
        NSLog(@"%@", error);
    
    [self updateViewForPlayerInfo:self.audioPlayer];
    [self updateViewForPlayerState:self.audioPlayer];
    
}
//
- (IBAction)nextButtonPressed {
    seconds = 0;
//    self.countDownLabel.text = [NSString stringWithFormat:@"%li",(long)seconds];
    self.countDownLabel.text = @"";
    [countTimer invalidate];
    [self next];
    [self updateViewForPlayerState:self.audioPlayer];
}

- (void)next
{
    NSUInteger newIndex;
    
    if (self.shuffleButton.selected)
    {
        newIndex = rand() % [self.query count];
    }
    else if (self.repeatOne)
    {
        newIndex = self.selectedIndex;
    }
    else if (self.repeatAll)
    {
        if (self.selectedIndex + 1 == [self.query count])
            newIndex = 0;
        else
            newIndex = self.selectedIndex + 1;
    }
    else
    {
        if (self.selectedIndex + 1 == [self.query count])
            return;
        else
            newIndex = self.selectedIndex + 1;
    }
    
    self.selectedIndex = newIndex;
    
    NSError *error = nil;
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/%@",
                               [[NSBundle mainBundle] resourcePath], [self.query objectAtIndex:self.selectedIndex]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    AVAudioPlayer *newAudioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    
    self.audioPlayer = newAudioPlayer;
    
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    
    if (error)
        NSLog(@"%@", error);
    
    [self updateViewForPlayerInfo:self.audioPlayer];
    //    [self updateViewForPlayerState:self.audioPlayer];
}

- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
    if (p.playing)
    {
        [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"Controls_Pause.png"]
                                        forState:UIControlStateNormal];
    }
    else
    {
        [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"Controls_Play.png"]
                                        forState:UIControlStateNormal];
        self.isPaused = TRUE;
    }
    
    
//    if (self.repeatOne || self.repeatAll || self.shuffle)
//        self.nextButton.enabled = YES;
//    else
//        self.nextButton.enabled = [self canGoToNextTrack];
//    self.previousButton.enabled = [self canGoToPreviousTrack];
    
}

//- (BOOL)canGoToNextTrack
//{
//    if (self.selectedIndex + 1 == [self.query count])
//        return NO;
//    else
//        return YES;
//}
//
//- (BOOL)canGoToPreviousTrack
//{
//    if (self.selectedIndex == 0)
//        return NO;
//    else
//        return YES;
//}

-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p
{
    self.trackLengthLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)p.duration / 60, (int)p.duration % 60, nil];
//    self.indexLabel.text = [NSString stringWithFormat:@"%d of %d", (self.selectedIndex + 1), [self.query count]];
    self.songLabel.text = [[self.query objectAtIndex:self.selectedIndex] stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
    self.progressSlider.maximumValue = p.duration;
}


- (IBAction)replayClicked:(id)sender {
//    [self.audioPlayer setCurrentTime:0.0];
    [self.audioPlayer stop];
    self.progressSlider.value = 0;
    [self.audioPlayer setCurrentTime:0.0];
    [self.audioPlayer play];
}


- (IBAction)pikcAndSoundClicked {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    [timer pause];
    [timer reset];
    
    [self.timer invalidate];
    
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.isAllSoundsView) {
        AllSoundsViewController *allSoundsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AllSoundsViewController"];
        allSoundsVC.selectedIndex = self.selectedIndex;
        [self.navigationController pushViewController:allSoundsVC animated:YES];
    } else {
        LightingRoundViewController *lightingRoundVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LightingRoundViewController"];
        lightingRoundVC.selectedIndex = self.selectedIndex;
        lightingRoundVC.isFromPlayVC = YES;
        [self.navigationController pushViewController:lightingRoundVC animated:YES];
    }
}

- (IBAction)soundsFunClicked:(id)sender {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    [timer pause];
    [timer reset];
    
    [self.timer invalidate];
    
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.isAllSoundsView) {
        AllSoundsViewController *allSoundsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AllSoundsViewController"];
        allSoundsVC.selectedIndex = self.selectedIndex;
        [self.navigationController pushViewController:allSoundsVC animated:YES];
    } else {
        LightingRoundViewController *lightingRoundVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LightingRoundViewController"];
        lightingRoundVC.selectedIndex = self.selectedIndex;
        lightingRoundVC.isFromPlayVC = YES;
        [self.navigationController pushViewController:lightingRoundVC animated:YES];
    }
}


- (IBAction)volumeChanged:(UISlider *)sender {
    self.panningVolume = YES;
    self.audioPlayer.volume = sender.value;
}

- (IBAction)volumeEnd {
    self.panningVolume = NO;
}

- (IBAction)progressChanged:(UISlider *)sender {
    // While dragging the progress slider around, we change the time label,
    // but we're not actually changing the playback time yet.
    self.panningProgress = YES;
    self.trackCurrentPlaybackTimeLabel.text = [NSString stringFromTime:sender.value];
}

- (IBAction)progressEnd {
    // Only when dragging is done, we change the playback time.
    self.audioPlayer.currentTime = self.progressSlider.value;
    self.panningProgress = NO;
}

- (IBAction)shuffleButtonPressed {
    self.shuffleButton.selected = !self.shuffleButton.selected;
    
    if (self.shuffleButton.selected) {
        [self.shuffleButton setImage:[UIImage imageNamed:@"Track_Shuffle_On"]
                       forState:UIControlStateNormal];
        
    } else {
        [self.shuffleButton setImage:[UIImage imageNamed:@"Track_Shuffle_Off"]
                            forState:UIControlStateNormal];
    }
    
    [self updateViewForPlayerInfo:self.audioPlayer];
//    [self updateViewForPlayerState:self.audioPlayer];
}


- (IBAction)repeatButtonPressed {
    if (self.repeatOne)
    {
        [self.repeatButton setImage:[UIImage imageNamed:@"Track_Repeat_Off"]
                      forState:UIControlStateNormal];
        self.repeatOne = NO;
        self.repeatAll = NO;
    }
    else if (self.repeatAll)
    {
        [self.repeatButton setImage:[UIImage imageNamed:@"Track_Repeat_On_Track"]
                      forState:UIControlStateNormal];
        self.repeatOne = YES;
        self.repeatAll = NO;
    }
    else
    {
        [self.repeatButton setImage:[UIImage imageNamed:@"Track_Repeat_On"]
                      forState:UIControlStateNormal];
        self.repeatOne = NO;
        self.repeatAll = YES;
    }
    
    [self updateViewForPlayerInfo:self.audioPlayer];
//    [self updateViewForPlayerState:self.audioPlayer];
}

#pragma mark -
#pragma mark AVAudioPlayer delegate


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    if (flag == NO)
        NSLog(@"Playback finished unsuccessfully");
    if ((self.selectedIndex + 1 != [self.query count]) || self.shuffleButton.selected || self.repeatAll || self.repeatOne) {
//    if (self.selectedIndex + 1 != [self.query count]) {        
        if (self.shuffleButton.selected || self.repeatAll || self.repeatOne) {
//            [self next];
        } else {
//            seconds = 30;
//            self.countDownLabel.text = [NSString stringWithFormat:@"%li", (long)seconds];
//            countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subtractTime) userInfo:nil repeats:YES];
        }
//        [self next];
    } else {
        [self.audioPlayer stop];
    }
    
//    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"Controls_Play.png"]
//                                    forState:UIControlStateNormal];
//    self.isPaused = TRUE;
    [self updateViewForPlayerInfo:self.audioPlayer];
    [self updateViewForPlayerState:self.audioPlayer];
}

- (void)subtractTime {

    seconds--;
    self.countDownLabel.text = [NSString stringWithFormat:@"%li",(long)seconds];
    
    if (seconds == 0) {
        [countTimer invalidate];
        [self next];
    }
}

/*
#pragma mark - GVMusicPlayerControllerDelegate

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer playbackStateChanged:(MPMusicPlaybackState)playbackState previousPlaybackState:(MPMusicPlaybackState)previousPlaybackState {
    self.playPauseButton.selected = (playbackState == MPMusicPlaybackStatePlaying);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer trackDidChange:(MPMediaItem *)nowPlayingItem previousTrack:(MPMediaItem *)previousTrack {
    if (!nowPlayingItem) {
        self.chooseView.hidden = NO;
        return;
    }
    
    self.chooseView.hidden = YES;
    
    // Time labels
    NSTimeInterval trackLength = [[nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    self.trackLengthLabel.text = [NSString stringFromTime:trackLength];
    self.progressSlider.value = 0;
    self.progressSlider.maximumValue = trackLength;
    
    // Labels
    self.songLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    self.artistLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    
    // Artwork
    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        self.imageView.image = [artwork imageWithSize:self.imageView.frame.size];
    }
    
    NSLog(@"Proof that this code is being called, even in the background!");
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer endOfQueueReached:(MPMediaItem *)lastTrack {
    NSLog(@"End of queue, but last track was %@", [lastTrack valueForProperty:MPMediaItemPropertyTitle]);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer volumeChanged:(float)volume {
    if (!self.panningVolume) {
        self.volumeSlider.value = volume;
    }
}
*/

@end
