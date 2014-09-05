//
//  PhotoAnnotation.h
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/5/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface PhotoAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) NSNumber *photoLatitude;
@property (nonatomic, strong) NSNumber *photoLongitude;
@property (nonatomic, assign) NSInteger photoIdentifier;
@property (nonatomic, strong) NSString *photoTitle;
@property (nonatomic, strong) NSString *photoSubtitle;

- (NSString *)title;
- (NSString *)subtitle;

@end
