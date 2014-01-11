//
//  ZOMGame.h
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 03/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZOMGame : NSObject

@property NSUInteger numZombies;
@property NSUInteger zombieSpeed;
@property NSArray *zombies; // of ZOMZombie

- (id) initWithNumZombies:(NSUInteger)number withSpeed:(NSUInteger)speed;


@end
