//
//  AllSoundsViewController.h
//  GeneratingSounds
//
//  Created by admin on 01/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AllSoundsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end
