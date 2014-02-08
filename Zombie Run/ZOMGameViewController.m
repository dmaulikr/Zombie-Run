//
//  ZOMGameViewController.m
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 03/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import "ZOMGameViewController.h"

@interface ZOMGameViewController ()

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Places the ZOMZombieAnnotation(s) randomly on the map at at least a calculated
// distance form the user. The idea here is that the zombies must lie outside of a
// certain "buffer distance" which is calculated as a 1 minute time-to-user given
// the set zombie speed.
- (void)placeZombiesOnMap {
    // Get the user's location, depending on which we'll place the zombies
    MKMapPoint userMapPointLocation = MKMapPointForCoordinate(self.map.userLocation.coordinate);
    
    // Calculate the "buffer distance", which is the number of meters a zombie
    // can cover in one minute
    double numberMapPointsPerMeter = MKMapPointsPerMeterAtLatitude(self.map.userLocation.coordinate.latitude);
    // Defined as the number of meters that a zombie can run in a minute
    unsigned long bufferDistanceInMeters = ((self.game.zombieSpeed * 1000) / 60);
    
    // For the number of zombies in this game, make an annotation and add it to the game map
    for (int i = 0; i < self.game.numZombies; i++) {
        ZOMZombieAnnotation *zombieAnnotation = [[ZOMZombieAnnotation alloc] init];
        MKMapPoint zombieMapPointLocation;
        // We place the zombie a random latitude and longitude away from the user
        // with either the latitude or longitude being at least the "buffer
        // distance" away and a max of 2 * the "buffer distance"
        long xChangeInMeters = (arc4random() % (bufferDistanceInMeters * 2)) - bufferDistanceInMeters;
        long yChangeInMeters = (arc4random() % (bufferDistanceInMeters * 2)) - bufferDistanceInMeters;
        if ((arc4random() % 100) > 50) {
            xChangeInMeters = (xChangeInMeters > 0) ? xChangeInMeters + bufferDistanceInMeters : xChangeInMeters - bufferDistanceInMeters;
        } else {
            yChangeInMeters = (yChangeInMeters > 0) ? yChangeInMeters + bufferDistanceInMeters : yChangeInMeters - bufferDistanceInMeters;
        }
        zombieMapPointLocation.x = userMapPointLocation.x + (numberMapPointsPerMeter * xChangeInMeters);
        zombieMapPointLocation.y = userMapPointLocation.y + (numberMapPointsPerMeter * yChangeInMeters);
        [zombieAnnotation setCoordinate:MKCoordinateForMapPoint(zombieMapPointLocation)];
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
    
    // TODO: Include the ability to use miles instead of kilometers
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
            MKMapPoint zombieMapPointLocation = MKMapPointForCoordinate(zombieLocation);
            
            // Randomly move the zombie laterally or vertically
            if ((arc4random() % 100) > 50) {
                 zombieMapPointLocation.y = (zombieLocation.latitude < userLocation.latitude) ? zombieMapPointLocation.y - numberMapPointsPerCentimeter : zombieMapPointLocation.y + numberMapPointsPerCentimeter;
            } else {
                zombieMapPointLocation.x = (zombieLocation.longitude < userLocation.longitude) ? zombieMapPointLocation.x + numberMapPointsPerCentimeter : zombieMapPointLocation.x - numberMapPointsPerCentimeter;
            }
            
            // Move the zombie's Annotation View to the new coordinate
            zombieLocation = MKCoordinateForMapPoint(zombieMapPointLocation);
            zombieAnnotation.coordinate = zombieLocation;
            
            // TODO: Check for end-game state
        }
    }
}

#pragma mark MKMapView Delegate
    
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // Zoom in to and center the user withina five-kilomer radius
    if (self.game.isNewGame) {
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
        // Place zombies in the vicinity of the newly-placed user
        [self placeZombiesOnMap];
        self.game.newGame = NO;
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
