//
//  ZOMGameViewController.m
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 03/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import "ZOMGameViewController.h"

@interface ZOMGameViewController ()

@property (getter = isFirstTimeLocatingUser) BOOL firstTimeLocatingUser;
@property (weak) NSTimer *repeatingTimer;

@end

@implementation ZOMGameViewController

// **Designated Initializer**
// @param ZOMGame *game : the game supplying model data to this view controller
// @return id : the resulting ZOMGameViewController with the given ZOMGame as its model object
- (id)initWithGame:(ZOMGame *)game
{
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
        [zombieAnnotation setCoordinate:coordinate];
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
    
    // TODO: Convert miles to kilometers
    // Setup the speed of the zombies by calculating the number of
    // centimeters the zombie will need to travel each second given
    // the set speed
    double numCentimetersPerSecond = ((self.game.zombieSpeed * 1.0) / 60 / 60) * 100000;
    
    // Have the timer move the zombie the appropriate times per second
    // to give it the speed set by the user
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:(1 / numCentimetersPerSecond)
                                                      target:self selector:@selector(updateZombieLocations)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
}

// Moves all of the zombies a centimeter towards the user either
// laterally or vertically
- (void)updateZombieLocations {
    // Get the user location to track towards
    CLLocationCoordinate2D userLocation = self.map.userLocation.coordinate;
    
    // For the number of zombies in this game, make an annotation and add it to the game map
    for (ZOMZombieAnnotation *zombieAnnotation in self.map.annotations) {
        if ([zombieAnnotation isKindOfClass:[ZOMZombieAnnotation class]]) {
            // First find out how many centimeters are in a point on the map measured
            // in MapPoints
            double numberMapPointsPerCentimeter = MKMapPointsPerMeterAtLatitude(zombieAnnotation.coordinate.latitude) / 100;
            
            // Pull the zombie's location as both a coordinate and then a MKMapPoint
            CLLocationCoordinate2D zombieLocation = zombieAnnotation.coordinate;
            MKMapPoint zombieMapPointLocation = MKMapPointForCoordinate(zombieAnnotation.coordinate);
            
            // Randomly move the zombie laterally or vertically
            if ((arc4random() % 1) > 0.5) {
                 zombieMapPointLocation.y = (zombieLocation.latitude < userLocation.latitude) ? zombieMapPointLocation.y + numberMapPointsPerCentimeter : zombieMapPointLocation.y - numberMapPointsPerCentimeter;
            } else {
                zombieMapPointLocation.x = (zombieLocation.longitude < userLocation.longitude) ? zombieMapPointLocation.x + numberMapPointsPerCentimeter: zombieMapPointLocation.x - numberMapPointsPerCentimeter;
            }
            
            // Animate the zombie to the new location by converting the MKMapPoint
            // back to a coordinate and setting it to the zombie's location
            zombieLocation = MKCoordinateForMapPoint(zombieMapPointLocation);
            [UIView animateWithDuration:1.0 animations:^{
                [zombieAnnotation setCoordinate:zombieLocation];
            }];
        }
    }
}

#pragma mark MKMapView Delegate
    
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // Zoom in to and center the user withina five-kilomer radius
    if (self.isFirstTimeLocatingUser) {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        CLLocationCoordinate2D location;
        location.latitude = userLocation.coordinate.latitude;
        location.longitude = userLocation.coordinate.longitude;
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;
        region.span = span;
        region.center = location;
        [mapView setRegion:region animated:YES];
        self.firstTimeLocatingUser = NO;
        // Place zombies in the vicinity of the newly-placed user
        [self placeZombiesOnMap];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        // TODO: Make this a custom MKAnnotationView, or an arrow or something
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
