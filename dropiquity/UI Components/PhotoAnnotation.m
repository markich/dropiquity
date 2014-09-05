//
//  PhotoAnnotation.m
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/5/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import "PhotoAnnotation.h"

@implementation PhotoAnnotation

@synthesize photoImage;
@synthesize photoLatitude;
@synthesize photoLongitude;
@synthesize photoIdentifier;
@synthesize photoTitle;
@synthesize photoSubtitle;

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.photoLatitude doubleValue];
    theCoordinate.longitude = [self.photoLongitude doubleValue];
    
    return theCoordinate;
}

- (NSString *)title
{
    return self.photoTitle;
}

- (NSString *)subtitle
{
    return self.photoSubtitle;
}

@end
