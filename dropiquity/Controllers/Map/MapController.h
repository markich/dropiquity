//
//  MapController.h
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/5/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import "PhotoAnnotation.h"

@interface MapController : UIViewController <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSMutableDictionary * imageCache;

@property (nonatomic, strong) UIImage *photo;

@end
