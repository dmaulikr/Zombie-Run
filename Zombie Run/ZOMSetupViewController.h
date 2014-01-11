//
//  ZOMSetupViewController.h
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 03/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOMGame.h"
#import "ZOMGameViewController.h"

@interface ZOMSetupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *zombieSpeedLabel;
@property (strong, nonatomic) IBOutlet UISlider *zombieSpeedSlider;

@property (strong, nonatomic) IBOutlet UILabel *numZombiesLabel;
@property (strong, nonatomic) IBOutlet UISlider *numZombiesSlider;

- (IBAction)changedSetup:(id)sender;


@end
