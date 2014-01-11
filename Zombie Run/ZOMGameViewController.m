//
//  ZOMGameViewController.m
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 03/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import "ZOMGameViewController.h"

#define CLICK_DISTANCE 0.001 // about .001 kilometers

@interface ZOMGameViewController ()

@property (getter = isFirstTimeLocatingUser) BOOL firstTimeLocatingUser;
@property (weak) NSTimer *repeatingTimer;

@end

@implementation ZOMGameViewController

// **Designated Initializer**
// @param ZOMGame *game : the game supplying model data to this view controller
// @return id : the resulting ZOMGameViewController with the given ZOMGame as its model object
- (id)initWithGame:(ZOMGame *)game {
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.map.mapType = MKMapTypeHybrid;
    self.map.showsUserLocation = YES;
    self.map.delegate = self;
    
    // The next time the user is located it will be the first time, that is when we set the default zoom-level
    self.firstTimeLocatingUser = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Places the ZOMZombieAnnotation(s) on-screen using their coordinates
- (void)placeZombiesOnMap {
    // For the number of zombies in this game, make an annotation and add it to the game map
    for (int i = 0; i < self.game.numZombies; i++) {
        ZOMZombieAnnotation *zombieAnnotation = [[ZOMZombieAnnotation alloc] init];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = self.map.userLocation.coordinate.latitude;
        coordinate.longitude = self.map.userLocation.coordinate.longitude + (0.008 * (i+1));
        zombieAnnotation.coordinate = coordinate;
        [self.map addAnnotation:zombieAnnotation];
    }
    
    // Begin the timer which will call to update the zombies' locations at the interval set by the user in the set-up phase
    [self startRepeatingTimer];
}

// Starts the repeating timer which will be used to fire the
// update zombie location method at the appropriate interval
- (void)startRepeatingTimer {

    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];

    // TODO: Make the zombie speed convert to a usable interval
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.game.zombieSpeed
                                                      target:self selector:@selector(updateZombieLocations)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
}

// TODO: Track towards the user
- (void)updateZombieLocations {
    // Get the user location to track towards
    CLLocationCoordinate2D userLocation = self.map.userLocation.coordinate;
    
    // For the number of zombies in this game, make an annotation and add it to the game map
    for (ZOMZombieAnnotation *zombieAnnotation in self.map.annotations) {
        if ([zombieAnnotation isKindOfClass:[ZOMZombieAnnotation class]]) {
            CLLocationCoordinate2D zombieLocation = zombieAnnotation.coordinate;
            double newZombieLatitude = (zombieLocation.latitude < userLocation.latitude) ? zombieLocation.latitude + CLICK_DISTANCE : zombieLocation.latitude - CLICK_DISTANCE;
            double newZombieLongitude = (zombieLocation.longitude < userLocation.longitude) ? zombieLocation.longitude + CLICK_DISTANCE : zombieLocation.longitude - CLICK_DISTANCE;
            CLLocationCoordinate2D newZombieCoordinate = CLLocationCoordinate2DMake(newZombieLatitude, newZombieLongitude);
            [zombieAnnotation setCoordinate:newZombieCoordinate];
        }
    }
}

#pragma mark MKMapView Delegate
    
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    // Zoom in to a five-kilomer radius of the user initially
    if (self.isFirstTimeLocatingUser) {
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;
        self.firstTimeLocatingUser = NO;
        // Place zombies in the vicinity of the newly-placed user
        [self placeZombiesOnMap];
    } else {
        // Otherwise, we leave the maps region as the user has set it
        span = self.map.region.span;
    }
    // Update the region to have the users location in the center
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    // If we're looking for a zombie, dequeue one if available, or simply create a new one
    } else if ([annotation isKindOfClass:[ZOMZombieAnnotation class]]){
        ZOMZombieAnnotationView *zombieView = (ZOMZombieAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomZombieAnnotationView"];
        
        if (!zombieView) {
            zombieView = [[ZOMZombieAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomZombieAnnotationView"];
        }
        
        return zombieView;
    }
    
    
    return nil;
}

@end
