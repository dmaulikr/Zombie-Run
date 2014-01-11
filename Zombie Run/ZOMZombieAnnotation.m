//
//  ZOMZombieAnnotation.m
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 11/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import "ZOMZombieAnnotation.h"

@implementation ZOMZombieAnnotation

/* Designated Initializer */
- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    if (self) {
        self.coordinate = coordinate;
    }
    
    return self;
}

@end
