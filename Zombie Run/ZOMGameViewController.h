//
//  ZOMGameViewController.h
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 03/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ZOMGame.h"
#import "ZOMZombieAnnotation.h"
#import "ZOMZombieAnnotationView.h"

@interface ZOMGameViewController : UIViewController <MKMapViewDelegate>

// Serves up the model data for this ZOMGameViewController
@property (strong, nonatomic) ZOMGame *game;

// Displays the players' and zombies' locations
@property (strong, nonatomic) IBOutlet MKMapView *map;

@end
