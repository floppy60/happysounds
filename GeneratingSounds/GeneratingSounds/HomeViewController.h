//
//  HomeViewController.h
//  GeneratingSounds
//
//  Created by admin on 28/03/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface HomeViewController : UIViewController<MZTimerLabelDelegate>
{
    MZTimerLabel *timer;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UIButton *btnStartPause;
- (IBAction)startOrResumeStopwatch:(id)sender;
- (IBAction)resetStopWatch:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *timerView;

@property (nonatomic, strong) AVAudioPlayer *player;//for ding

@end

