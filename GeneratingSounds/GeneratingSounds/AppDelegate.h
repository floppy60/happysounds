//
//  AppDelegate.h
//  GeneratingSounds
//
//  Created by admin on 28/03/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *savedPickedNames;
@property (strong, nonatomic) NSMutableArray* savedChecked;
@property NSInteger savedGuessNumber;
@property (nonatomic) NSInteger currentTime;

@end

