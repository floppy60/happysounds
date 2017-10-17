//
//  LightingRoundViewController.m
//  GeneratingSounds
//
//  Created by admin on 25/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "LightingRoundViewController.h"
#import "HomeViewController.h"
#import "PlayerViewController.h"
#include <stdlib.h>
#import "RoundTableViewCell.h"
#import "AppDelegate.h"

@interface LightingRoundViewController ()

@end

@implementation LightingRoundViewController{
    NSArray *directoryContents;
    NSMutableArray *pickedNames;
    NSMutableArray* names;
    NSMutableArray* checked;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"resourcePath %@", resourcePath);
    NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"Sounds"];
    
    NSError * error;
    directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    NSLog(@"directoryContents %@", directoryContents);
    
    names = [NSMutableArray arrayWithArray:directoryContents];
    NSLog(@"names %@", names);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!self.isFromPlayVC) {
        [self generateNewLightingRound];
        appDelegate.savedChecked = [[NSMutableArray alloc] init];
        for (int i=0; i<8; i++) {
            [appDelegate.savedChecked addObject:[NSNumber numberWithBool:NO]];
        }
        checked =  appDelegate.savedChecked;
        
        appDelegate.savedGuessNumber = 0;
        self.guessedNumberLbl.text = [NSString stringWithFormat:@"%li",(long)appDelegate.savedGuessNumber];
        
    } else {
        pickedNames = appDelegate.savedPickedNames;
        checked =  appDelegate.savedChecked;
        self.guessedNumberLbl.text = [NSString stringWithFormat:@"%li",(long)appDelegate.savedGuessNumber];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    previousIndex = self.selectedIndex;
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    if (!self.isFromPlayVC) {
        seconds = 0;
        self.lblTimer.text = [NSString stringWithFormat:@"%02ld",(long)(seconds%60)];
    } else {
        seconds = appDelegate.currentTime;
        self.lblTimer.text = [NSString stringWithFormat:@"%02ld",(long)(seconds%60)];
        [self timerStart];
        [self.btnStartPause setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
    self.audioPlayer.delegate = self;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.tableView.rowHeight = 100;
    }
    else {
        self.tableView.rowHeight = 55;
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerStart {
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)timerPause {
    [timer invalidate];
}

- (void)timerReset {
    seconds = 0;
    self.lblTimer.text = [NSString stringWithFormat:@"%02ld",(long)(seconds%60)];
    [timer invalidate];
    [self.btnStartPause setTitle:@"Start" forState:UIControlStateNormal];
}

- (void)updateTime {
    
    seconds++;
    self.lblTimer.text = [NSString stringWithFormat:@"%02ld",(long)(seconds%60)];
    
    if (seconds == 60) {
        [timer invalidate];
        seconds = 0;
        self.lblTimer.text = [NSString stringWithFormat:@"%02ld",(long)(seconds%60)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Bell-ding" ofType:@"mp3"];
        
        NSURL *file = [[NSURL alloc] initFileURLWithPath:path];
        
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
        [self.player prepareToPlay];
        [self.player play];
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        [self.btnStartPause setTitle:@"Start" forState:UIControlStateNormal];
    }
}


- (IBAction)startOrResumeStopwatch:(id)sender {
    
    if(timer.valid){
        [self.audioPlayer pause];
        
        [self timerPause];
        [self.btnStartPause setTitle:@"Resume" forState:UIControlStateNormal];
    }else{
        [self.audioPlayer play];
        
        [self timerStart];
        [self.btnStartPause setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)resetStopWatch:(id)sender {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    [self timerReset];
}


- (IBAction)goHome:(id)sender {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    [self timerReset];
    
    HomeViewController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:homeVC animated:YES];
}


- (IBAction)clickedNew:(id)sender {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    [self timerReset];
    
    [self generateNewLightingRound];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.savedChecked = [[NSMutableArray alloc] init];
    for (int i=0; i<8; i++) {
        [appDelegate.savedChecked addObject:[NSNumber numberWithBool:NO]];
    }
    checked =  appDelegate.savedChecked;
}

- (void)generateNewLightingRound {
    pickedNames = [NSMutableArray new];
    
    if (names.count == 0) {
        NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"Sounds"];
        NSError * error;
        directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
        names = [NSMutableArray arrayWithArray:directoryContents];
    }
    
    int remaining = 8;
    
    if (names.count >= remaining) {
        while (remaining > 0) {
            id name = names[arc4random_uniform(names.count)];
            
            if (![pickedNames containsObject:name]) {
                [pickedNames addObject:name];
                [names removeObject:name];
                remaining--;
            }
        }
    } else {
//        [pickedNames addObjectsFromArray:names];
//        [names removeAllObjects];
        NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"Sounds"];
        NSError * error;
        directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
        names = [NSMutableArray arrayWithArray:directoryContents];
        
        while (remaining > 0) {
            id name = names[arc4random_uniform(names.count)];
            
            if (![pickedNames containsObject:name]) {
                [pickedNames addObject:name];
                [names removeObject:name];
                remaining--;
            }
        }
        
    }
    NSLog(@"updatedMames %@", names);
    NSLog(@"ssss %@", pickedNames);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.savedPickedNames = pickedNames;
    
    appDelegate.savedGuessNumber = 0;
    self.guessedNumberLbl.text = [NSString stringWithFormat:@"%li",(long)appDelegate.savedGuessNumber];
    
    [self.tableView reloadData];
}

#pragma - markup TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pickedNames count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"LightingRoundCell";
    
    RoundTableViewCell *cell = (RoundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RoundTableViewCell" owner:self options:nil];
        
        NSArray *nib;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"RoundTableViewCell_iPad" owner:self options:nil];
        }
        else {
            nib = [[NSBundle mainBundle] loadNibNamed:@"RoundTableViewCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == previousIndex) {
        cell.backgroundColor = [UIColor colorWithWhite:0.851 alpha:1.000];
    }
    
    if (indexPath.row%4 == 0) {
        [cell.playButton setBackgroundImage:[UIImage imageNamed:@"sf-app-ligthning-button-a.png"] forState:UIControlStateNormal];
    } else if (indexPath.row%4 == 1) {
        [cell.playButton setBackgroundImage:[UIImage imageNamed:@"sf-app-ligthning-button-b.png"] forState:UIControlStateNormal];
    } else if (indexPath.row%4 == 2) {
        [cell.playButton setBackgroundImage:[UIImage imageNamed:@"sf-app-ligthning-button-c.png"] forState:UIControlStateNormal];
    } else {
        [cell.playButton setBackgroundImage:[UIImage imageNamed:@"sf-app-ligthning-button-d.png"] forState:UIControlStateNormal];
    }
    
    if (![[checked objectAtIndex:indexPath.row] boolValue]) {
        if (indexPath.row%4 == 0) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked-a.png"];
        } else if (indexPath.row%4 == 1) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked-b.png"];
        } else if (indexPath.row%4 == 2) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked-c.png"];
        } else {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked-d.png"];
        }
    } else {
        if (indexPath.row%4 == 0) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked-a.png"];
        } else if (indexPath.row%4 == 1) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked-b.png"];
        } else if (indexPath.row%4 == 2) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked-c.png"];
        } else {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked-d.png"];
        }
    }
    
    
    [[cell descriptionLabel] setNumberOfLines:0]; // unlimited number of lines
    [[cell descriptionLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    cell.descriptionLabel.text = [[pickedNames objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
//    cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked.png"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChecking:)];
    [cell.touchImage addGestureRecognizer:tap];
    cell.touchImage.userInteractionEnabled = YES;
    
    cell.playButton.tag = indexPath.row;
    
    [cell.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!timer.valid) {
        [self timerStart];
        [self.btnStartPause setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
//    if (indexPath.row != previousIndex) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        
        RoundTableViewCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:previousIndex inSection:0]];
        cell.backgroundColor = [UIColor clearColor];
        previousIndex = indexPath.row;
    
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/%@",
                               [[NSBundle mainBundle] resourcePath], [pickedNames objectAtIndex:indexPath.row]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                              error:nil];
        [self.audioPlayer play];
//    }
    
    /*AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentTime = seconds;
    [timer invalidate];
    
    PlayerViewController *PlayerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    PlayerVC.query = pickedNames;
    
    RoundTableViewCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:previousIndex inSection:0]];
    cell.backgroundColor = [UIColor clearColor];
    
    PlayerVC.selectedIndex = indexPath.row;
    previousIndex = indexPath.row;
    [self.navigationController pushViewController:PlayerVC animated:YES];*/
}

-(void)playButtonClicked:(UIButton*)sender
{
//    if (sender.tag == 0)
//    {
//        // Your code here
//    }
    
    if (!timer.valid) {
        [self timerStart];
        [self.btnStartPause setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
//    if (sender.tag != previousIndex) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        
        RoundTableViewCell *originCell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:previousIndex inSection:0]];
        originCell.backgroundColor = [UIColor clearColor];
        RoundTableViewCell *newCell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:sender.tag inSection:0]];
        newCell.backgroundColor = [UIColor colorWithWhite:0.851 alpha:1.000];
        previousIndex = sender.tag;
    
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/%@",
                               [[NSBundle mainBundle] resourcePath], [pickedNames objectAtIndex:sender.tag]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                              error:nil];
        [self.audioPlayer play];
//    }
    
    /*AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentTime = seconds;
    [timer invalidate];
    
    PlayerViewController *PlayerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    PlayerVC.query = pickedNames;
    
    RoundTableViewCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:previousIndex inSection:0]];
    cell.backgroundColor = [UIColor clearColor];
    
    PlayerVC.selectedIndex = sender.tag;
    previousIndex = sender.tag;
    [self.navigationController pushViewController:PlayerVC animated:YES];*/
}

- (void) handleChecking:(UITapGestureRecognizer *)tapRecognizer {
    
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    CGPoint tapLocation = [tapRecognizer locationInView:self.tableView];
    NSIndexPath *tappedIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    RoundTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tappedIndexPath];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![[appDelegate.savedChecked objectAtIndex:tappedIndexPath.row] boolValue])
    {
//        cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked.png"];
        if (tappedIndexPath.row%4 == 0) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked-a.png"];
        } else if (tappedIndexPath.row%4 == 1) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked-b.png"];
        } else if (tappedIndexPath.row%4 == 2) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked-c.png"];
        } else {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxChecked-d.png"];
        }
        [appDelegate.savedChecked replaceObjectAtIndex:tappedIndexPath.row withObject:[NSNumber numberWithBool:YES]];
        NSLog(@"sfdsfs %@", [NSString stringWithFormat: @"%ld", (long)appDelegate.savedGuessNumber]);
        appDelegate.savedGuessNumber++;
        NSLog(@"sfdsfs %@", [NSString stringWithFormat: @"%ld", (long)appDelegate.savedGuessNumber]);
        self.guessedNumberLbl.text = [NSString stringWithFormat:@"%li",(long)appDelegate.savedGuessNumber];
    }
    else
    {
//        cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked.png"];
        if (tappedIndexPath.row%4 == 0) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked-a.png"];
        } else if (tappedIndexPath.row%4 == 1) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked-b.png"];
        } else if (tappedIndexPath.row%4 == 2) {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked-c.png"];
        } else {
            cell.checkImage.image = [UIImage imageNamed:@"checkBoxUnChecked-d.png"];
        }
        
        [appDelegate.savedChecked replaceObjectAtIndex:tappedIndexPath.row withObject:[NSNumber numberWithBool:NO]];
        appDelegate.savedGuessNumber--;
        self.guessedNumberLbl.text = [NSString stringWithFormat:@"%li",(long)appDelegate.savedGuessNumber];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
