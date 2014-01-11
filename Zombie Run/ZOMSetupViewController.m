//
//  ZOMSetupViewController.m
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 03/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import "ZOMSetupViewController.h"

@interface ZOMSetupViewController ()

@end

@implementation ZOMSetupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Initialize the UI to its initial state
    [self updateUI];
    
}

// Syncronizes the UI with the currently supplied values
- (void)updateUI
{
    int zombieSpeed = (int)self.zombieSpeedSlider.value;
    self.zombieSpeedLabel.text = [NSString stringWithFormat:@"%d", zombieSpeed];
    int numZombies = (int)self.numZombiesSlider.value;
    self.numZombiesLabel.text = [NSString stringWithFormat:@"%d", numZombies];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Launch Game"]) {
        if ([segue.destinationViewController isMemberOfClass:[ZOMGameViewController class]]) {
            ZOMGameViewController *destinationController = (ZOMGameViewController *)segue.destinationViewController;
            ZOMGame *game = [[ZOMGame alloc] initWithNumZombies:[self.numZombiesLabel.text intValue] withSpeed:[self.zombieSpeedLabel.text intValue]];
            destinationController.game = game;
        }
    }
}

// Updates the UI whenever settings have been changed by the user
// @param id sender : the UI element used to make the change
// @return IBAction : the resulting UI change made as a result
- (IBAction)changedSetup:(id)sender {
    [self updateUI];
}
@end
