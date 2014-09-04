//
//  LoginController.m
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
- (void)updateButtons;
@end

@implementation LoginController

@synthesize linkButton;
@synthesize photoListController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Photos" style:UIBarButtonItemStylePlain target:self action:@selector(didPressPhotos)];
    
    if ([[DBSession sharedSession] isLinked])
    {
        [self didPressPhotos];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateButtons];
}

- (IBAction)didPressLinkButton:(id)sender
{
    [self didPressLink];
}

- (void)didPressLink
{
    if (![[DBSession sharedSession] isLinked])
    {
		[[DBSession sharedSession] linkFromController:self];
    }
    else
    {
        [[DBSession sharedSession] unlinkAll];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Unlinked!"
                                                        message:@"Your dropbox account has been unlinked"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        [self updateButtons];
    }
}

- (void)updateButtons
{
    BOOL isLinked = [[DBSession sharedSession] isLinked];
    
    NSString *title = isLinked ? @"Unlink with Dropbox" : @"Link with Dropbox";
    
    [self.linkButton setTitle:title forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem.enabled = isLinked;
}

- (void)didPressPhotos
{
    [self performSegueWithIdentifier:@"photoListSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
