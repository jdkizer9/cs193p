//
//  ImageViewController.m
//  Imaginarium
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic) BOOL userHasZoomed;
@end

@implementation ImageViewController

#pragma mark - View Controller Lifecycle

// add the UIImageView to the MVC's View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - Properties

// lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

// image property does not use an _image instance variable
// instead it just reports/sets the image in the imageView property
// thus we don't need @synthesize even though we implement both setter and getter

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    if (image)
    {
        self.imageView.image = image; // does not change the frame of the UIImageView
        
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        // self.scrollView could be nil on the next line if outlet-setting has not happened yet
        self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
        self.userHasZoomed = NO;
        [self setZoomScaleOfScrollView:self.scrollView forImage:self.image animated:NO];
        
        [self.spinner stopAnimating];
    }
    else
    {
        self.scrollView.zoomScale = 1.0;
        self.imageView.image = nil;
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
        //[self.spinner startAnimating];
    }
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    // next three lines are necessary for zooming
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;

    // next line is necessary in case self.image gets set before self.scrollView does
    // for example, prepareForSegue:sender: is called before outlet-setting phase
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

//this sets the appropriate zoom scale based on scrollView's frame size
//and the image's size
- (void)setZoomScaleOfScrollView:(UIScrollView *)scrollView forImage:(UIImage *)image animated:(BOOL)animated
{
    //get the scroll view's frame size
    //this also tells us whether we are in portrait or landscape
    CGSize scrollViewFrameSize = scrollView.frame.size;
    CGSize imageSize = image.size;
    
    //for width and height, get the frameSize to imageSize ratio
    CGFloat widthRatio = scrollViewFrameSize.width / imageSize.width;
    CGFloat heightRatio = scrollViewFrameSize.height / imageSize.height;
    
    //set zoomScale to the greater ratio
    if (animated)
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             scrollView.zoomScale = (widthRatio > heightRatio) ? widthRatio : heightRatio;
                         }
                         completion:nil];
    else
        scrollView.zoomScale = (widthRatio > heightRatio) ? widthRatio : heightRatio;
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    if (!self.userHasZoomed)
        [self setZoomScaleOfScrollView:self.scrollView forImage:self.image animated:YES];
}

#pragma mark - UIScrollViewDelegate

// mandatory zooming method in UIScrollViewDelegate protocol

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.userHasZoomed = YES;
}

#pragma mark - Setting the Image from the Image's URL

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    //    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]]; // blocks main queue!
    [self startDownloadingImage];
}

- (void)startDownloadingImage
{
    self.image = nil;

    if (self.imageURL)
    {
        [self.spinner startAnimating];

        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                // this handler is not executing on the main queue, so we can't do UI directly here
                if (!error) {
                    if ([request.URL isEqual:self.imageURL]) {
                        // UIImage is an exception to the "can't do UI here"
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                        // but calling "self.image =" is definitely not an exception to that!
                        // so we must dispatch this back to the main queue
                        dispatch_async(dispatch_get_main_queue(), ^{ self.image = image; });
                    }
                }
        }];
        [task resume]; // don't forget that all NSURLSession tasks start out suspended!
    }
}

#pragma mark - UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    id master = popoverController.contentViewController;
    
    if ([master isKindOfClass:[UITabBarController class]])
        self.navigationItem.leftBarButtonItem.title = [self getNavigationTitleFromTabBarController:(UITabBarController *)master];
    
    return YES;
    
}


#pragma mark - UISplitViewControllerDelegate

// this section added during Shutterbug demo

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (NSString *)getNavigationTitleFromTabBarController:(UITabBarController *)aTabBarController
{
    NSString *navTitle = @"";
    UINavigationController *nav = (UINavigationController *)[aTabBarController selectedViewController];
    if ([nav isKindOfClass:([UINavigationController class])])
    {
        navTitle = [NSString stringWithString:nav.navigationBar.topItem.title];
    }
    return navTitle;
    
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)master
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    
    //set the UIPopoverController delegate to self
    pc.delegate = self;
    //need to extract the title from whatever view controller is up
    //aViewController will be UITabBarController
    if ([master isKindOfClass:[UITabBarController class]])
        barButtonItem.title = [self getNavigationTitleFromTabBarController:(UITabBarController *)master];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)master
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
