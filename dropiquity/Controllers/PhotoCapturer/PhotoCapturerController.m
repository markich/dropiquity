//
//  PhotoCapturerController.m
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import "PhotoCapturerController.h"

@interface PhotoCapturerController ()
- (void)uploadPhotoToDropbox;
@end

@implementation PhotoCapturerController

@synthesize photo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(popController)];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [imagePicker setShowsCameraControls:YES];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePicker setAllowsEditing:YES];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -
#pragma mark

- (IBAction)uploadDidPressed:(id)sender
{
    [self.uploadButton setEnabled:NO];
    
    [SVProgressHUD showWithStatus:@"Uploading your photo..." maskType:SVProgressHUDMaskTypeGradient];
    
    [self uploadPhotoToDropbox];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (!info[UIImagePickerControllerEditedImage]) ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    
    self.photo = image;
    
    [self.photoView setImage:self.photo];
    
    [self dismissController];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissController];
}

#pragma mark -
#pragma mark Private Methods

- (void)dismissController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadPhotoToDropbox
{
    NSString *filename = [NSString stringWithFormat:@"photo_%@.png",[NSDate date]];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    
	NSData *photoData = [NSData dataWithData:UIImagePNGRepresentation(self.photo)];
	[photoData writeToFile:localPath atomically:YES];
    
    // Upload file to Dropbox
    NSString *destDir = @"/Photos";
    
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
}

- (DBRestClient*)restClient
{
    if (restClient == nil)
    {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    
    return restClient;
}

#pragma mark -
#pragma mark DBRestClientDelegate

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata
{
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    
    [SVProgressHUD showSuccessWithStatus:@"Your photo was successfully uploaded."];
    
    [self popController];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"There was an error uploading your photo."];
    
    [self.uploadButton setEnabled:YES];
    
    NSLog(@"File upload failed with error: %@", error);
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
