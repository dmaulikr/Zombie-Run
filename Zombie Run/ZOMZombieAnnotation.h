//
//  ZOMZombieAnnotation.h
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 11/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZOMZombieAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;


@end
