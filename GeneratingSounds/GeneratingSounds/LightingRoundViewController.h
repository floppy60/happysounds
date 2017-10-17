//
//  LightingRoundViewController.h
//  GeneratingSounds
//
//  Created by admin on 25/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LightingRoundViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger previousIndex;
    NSInteger seconds;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *guessedNumberLbl;

@property (weak, nonatomic) IBOutlet UILabel *lblTimer;

@property (weak, nonatomic) IBOutlet UIButton *btnStartPause;
- (IBAction)startOrResumeStopwatch:(id)sender;
- (IBAction)resetStopWatch:(id)sender;

@property (nonatomic) NSInteger selectedIndex;
@property BOOL isFromPlayVC;

@property (nonatomic, strong) AVAudioPlayer *player;//for ding
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end
