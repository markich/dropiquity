//
//  PhotoCell.m
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/4/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import "PhotoCell.h"

#import "CellBackground.h"

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CellBackground *backgroundView = [[CellBackground alloc] initWithFrame:CGRectZero];
        
        self.selectedBackgroundView = backgroundView;
    }
    return self;
}

@end
