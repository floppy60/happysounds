//
//  PlayerViewController.h
//  GeneratingSounds
//
//  Created by admin on 03/05/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MZTimerLabel.h"

@interface PlayerViewController : UIViewController<AVAudioPlayerDelegate, MZTimerLabelDelegate>
{
    NSInteger seconds;
    NSTimer *countTimer;
    MZTimerLabel *timer;
}

@property (nonatomic) NSArray *query;
@property (nonatomic) NSInteger selectedIndex;
@property BOOL isAllSoundsView;

@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UIButton *btnStartPause;
- (IBAction)startOrResumeStopwatch:(id)sender;
- (IBAction)resetStopWatch:(id)sender;

@property (nonatomic, strong) AVAudioPlayer *player;//for ding

@end
