//
//  WallPicturesViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import "WallPicturesViewController.h"
#import "UploadImageViewController.h"
#import <Parse/Parse.h>

@interface WallPicturesViewController () {

}

@property (nonatomic, retain) NSArray *wallObjectsArray;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;


-(void)getWallImages;
-(void)loadWallViews;
-(void)showErrorView:errorString;

@end

@implementation WallPicturesViewController

@synthesize wallObjectsArray = _wallObjectsArray;
@synthesize wallScroll = _wallScroll;
@synthesize activityIndicator = _loadingSpinner;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.wallScroll = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //Clean the scroll view
    for (id viewToRemove in [self.wallScroll subviews]){
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }

    //Reload the wall
    [self getWallImages];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Wall Load
//Load the images on the wall
-(void)loadWallViews
{
    //TODO: Put the wall objects in the scroll view
    int originY = 10;
    for (PFObject *wallImageObject in self.wallObjectsArray) {
        UIView *wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width -20, 300)];
        
        PFFile *file = [wallImageObject objectForKey:@"image"];
        UIImageView *userImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithData:file.getData]];
        userImageView.frame = CGRectMake(0, 0, wallImageView.frame.size.width, 200);
        [wallImageView addSubview:userImageView];
        
        NSString *commentString = [wallImageObject objectForKey:@"comment"];
        UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, wallImageView.frame.size.width, 15)];
        commentLabel.text = commentString;
        [wallImageView addSubview:commentLabel];
        
        NSDate *createdDate = wallImageObject.createdAt;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm"];
        
        UILabel *createdDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, wallImageView.frame.size.width, 15)];
        createdDateLabel.text = [dateFormatter stringFromDate:createdDate];
        [wallImageView addSubview:createdDateLabel];
        [self.wallScroll addSubview:wallImageView];
        
        originY = originY + wallImageView.frame.size.width + 20;
    }
    self.wallScroll.contentSize = CGSizeMake(self.wallScroll.frame.size.width, originY);
}



#pragma mark Receive Wall Objects

//Get the list of images
-(void)getWallImages
{
    //TODO: Get the wall objects from the server
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"WallImageObject"];
    [imageQuery orderByDescending:@"createdAt"];
    
    [imageQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.wallObjectsArray = objects;
            [self loadWallViews];
        }else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}


#pragma mark IB Actions


-(IBAction)logoutPressed:(id)sender
{
    //TODO
    //If logout succesful:
//    [self.navigationController popViewControllerAnimated:YES];
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg{
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}


@end
