//
//  AllSoundsViewController.m
//  GeneratingSounds
//
//  Created by admin on 01/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AllSoundsViewController.h"
#import "HomeViewController.h"
#import "LightingRoundViewController.h"
#import "PlayerViewController.h"

@interface AllSoundsViewController ()

@end

@implementation AllSoundsViewController {
    NSArray *directoryContents;
    NSMutableArray* names;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"ssss %@", resourcePath);
    NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"Sounds"];
    
    NSError * error;
    directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    NSLog(@"ssss %@", directoryContents);
    
    names = [NSMutableArray arrayWithArray:directoryContents];
    NSLog(@"names %@", names);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goHome:(id)sender {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    HomeViewController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:homeVC animated:YES];
}

- (IBAction)goLightingRound:(id)sender {
    LightingRoundViewController *lightingRoundVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LightingRoundViewController"];
    [self.navigationController pushViewController:lightingRoundVC animated:YES];
}

#pragma - markup TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [directoryContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SoundsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
//    if (cell == nil) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
//    }
    
    [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    cell.backgroundColor = [UIColor clearColor];

//    if (indexPath.row == self.selectedIndex) {
//        cell.backgroundColor = [UIColor colorWithWhite:0.851 alpha:1.000];
//    }
    
    cell.textLabel.text = [[directoryContents objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
    
    cell.imageView.image = [UIImage imageNamed:@"music_note.png"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*PlayerViewController *PlayerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    PlayerVC.query = names;
    PlayerVC.selectedIndex = indexPath.row;
    PlayerVC.isAllSoundsView = YES;
    [self.navigationController pushViewController:PlayerVC animated:YES];*/
    
    [self.audioPlayer stop];
    self.audioPlayer = nil;
        
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/%@",
                               [[NSBundle mainBundle] resourcePath], [names objectAtIndex:indexPath.row]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                              error:nil];
    [self.audioPlayer play];
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
