//
//  HomeViewController.m
//  GeneratingSounds
//
//  Created by admin on 28/03/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "HomeViewController.h"
#import "AllSoundsViewController.h"
#import "LightingRoundViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
    
    self.timerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.timerView.layer.borderWidth = 1.0f;
    
    timer = [[MZTimerLabel alloc] initWithLabel:self.lblTimer andTimerType:MZTimerLabelTypeStopWatch];
    timer.delegate = self;
    timer.timeFormat = @"ss";
    // Do any additional setup after loading the view, typically from a nib.
}

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
    [timer pause];
    [timer reset];
    
//    if(![timer counting]){
        [self.btnStartPause setTitle:@"Start" forState:UIControlStateNormal];
//    }
}

- (void)timerLabel:(MZTimerLabel *)timerlabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType{
    
    if([timerlabel isEqual:timer] && time > 30){
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goAllSounds:(id)sender {
    [timer pause]; //important! use these together.
    [timer reset];
    AllSoundsViewController *allSoundsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AllSoundsViewController"];
    [self.navigationController pushViewController:allSoundsVC animated:YES];
}

- (IBAction)goLightingRound:(id)sender {
    [timer pause];
    [timer reset];
    LightingRoundViewController *lightingRoundVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LightingRoundViewController"];
    lightingRoundVC.isFromPlayVC = NO;
    [self.navigationController pushViewController:lightingRoundVC animated:YES];
}

@end
