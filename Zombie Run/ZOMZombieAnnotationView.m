//
//  ZOMZombieAnnotationView.m
//  Zombie Run
//
//  Created by Hunter Kyle Gearhart on 11/01/2014.
//  Copyright (c) 2014 Hunter Kyle Gearhart. All rights reserved.
//

#import "ZOMZombieAnnotationView.h"

@implementation ZOMZombieAnnotationView

- (instancetype) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.image = [UIImage imageNamed:@"Mobster_2"];
        self.canShowCallout = NO;
        self.draggable = NO;
        self.enabled = NO;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
