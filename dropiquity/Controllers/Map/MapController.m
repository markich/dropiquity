//
//  MapController.m
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/5/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import "MapController.h"

#import "PhotoViewerController.h"

@interface MapController ()
- (void)showPhotosGeolocation;
- (IBAction)doCheckPhotoTriggered:(id)sender;
@end

@implementation MapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showPhotosGeolocation];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
    if ([annotation isKindOfClass:[PhotoAnnotation class]])
    {
		static NSString *photoAnnotationIdentifier = @"photoAnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:photoAnnotationIdentifier];
        if (!pinView)
        {
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:photoAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(doCheckPhotoTriggered:) forControlEvents:UIControlEventTouchUpInside];
            rightButton.tag = ((PhotoAnnotation *)annotation).photoIdentifier;
            
            //customPinView.rightCalloutAccessoryView = rightButton;
            
            UIView *leftAccesoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, customPinView.frame.size.height, customPinView.frame.size.height)];
            
            UIImageView * leftAccesoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, customPinView.frame.size.height-10, customPinView.frame.size.height-10)];
            [leftAccesoryImageView setImage:((PhotoAnnotation *)annotation).photoImage];
            [leftAccesoryImageView setContentMode:UIViewContentModeScaleAspectFit];
            
            [leftAccesoryView addSubview:leftAccesoryImageView];
            
            customPinView.leftCalloutAccessoryView = leftAccesoryView;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(doCheckPhotoTriggered:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
        }
        
        return pinView;
	}
    
    return nil;
}

- (void)showPhotosGeolocation
{
    MKCoordinateRegion newRegion;
    
    newRegion.center.latitude = [[NSNumber numberWithDouble:-38.012419] doubleValue];
    newRegion.center.longitude = [[NSNumber numberWithDouble:-57.5412684] doubleValue];
    newRegion.span.longitudeDelta = 0.002484;
    newRegion.span.latitudeDelta = 0.001368;
    
    NSMutableArray *annotationsArray = [@[] mutableCopy];
    
    NSArray *keyArray =  [self.imageCache allKeys];
    NSUInteger count = [keyArray count];
    
    for (int i = 0; i < count; i++)
    {
        double delta = ((i * 0.002484) / count);
        PhotoAnnotation *annotation = [[PhotoAnnotation alloc] init];
        annotation.photoTitle = @"Mar del Plata";
        annotation.photoSubtitle = [self.imageCache objectForKey:[keyArray objectAtIndex:i]];
        annotation.photoImage = [UIImage imageWithContentsOfFile:[keyArray objectAtIndex:i]];
        annotation.photoLatitude = [NSNumber numberWithDouble:-38.012419 - delta];
        annotation.photoLongitude = [NSNumber numberWithDouble:-57.5412684 - delta];
        
        [annotationsArray addObject:annotation];
    }
    
    [self.mapView setRegion:newRegion animated:NO];
    [self.mapView addAnnotations:annotationsArray];
}

- (IBAction)doCheckPhotoTriggered:(id)sender
{
    PhotoViewerController *viewerController = [[PhotoViewerController alloc] init];
    [viewerController setPhoto:self.photo];
    
    [self.navigationController pushViewController:viewerController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
