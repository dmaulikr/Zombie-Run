//
//  ZOMGame.m
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 03/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import "ZOMGame.h"

@interface ZOMGame()
@property NSArray *startingPoints; // of CLLocationCoordinate2D
@end

@implementation ZOMGame

/* Designated Initializer */
- (id) initWithNumZombies:(NSUInteger)number withSpeed:(NSUInteger)speed {
    self = [super init];
    
    if (self) {
        self.numZombies = number;
        self.zombieSpeed = speed;
        [self placeZombies];
    }
    
    return self;
}

- (void)placeZombies {
    
    // Generate the starting points of the zombies, which is dependent upon the number of zombies we start with
    [self generateStartingPoints];
    for (int i = 0; i < self.numZombies; i++) {
        //ZOMZombie *zombie = [[ZOMZombie alloc] initWithImage:[UIImage imageNamed:@"Zombie"] speed:self.zombieSpeed andLocation:(CLLocationCoordinate2D)[self.startingPoints objectAtIndex:i]];
    }
}

- (void)generateStartingPoints {
    
}

@end
