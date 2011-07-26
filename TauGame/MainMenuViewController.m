//
//  MainMenuViewController.m
//  TauGame
//
//  Created by Ian Terrell on 7/22/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "MainMenuViewController.h"
#import "TauGameAppDelegate.h"

@implementation MainMenuViewController

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

#pragma mark - Scene Setup

-(void)setupMenuPageWithWidth:(float)width height:(float)height numPages:(int)numPages block:(void (^)(UIView *))block {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(numPages * width, 0, height, width)];
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  block(view);
  [scrollView addSubview:view];
}

-(void)setupAsteroidsWithWidth:(float)width height:(float)height numPages:(int)numPages {
  [self setupMenuPageWithWidth:width height:height numPages:numPages block:^(UIView *view) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    label.text = @"Asteroids";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
  }];
}

-(void)setupSpaceInvadersWithWidth:(float)width height:(float)height numPages:(int)numPages {
  [self setupMenuPageWithWidth:width height:height numPages:numPages block:^(UIView *view) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    label.text = @"Space Invaders";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
  }];
}

-(void)setupSurvivalWithWidth:(float)width height:(float)height numPages:(int)numPages {
  [self setupMenuPageWithWidth:width height:height numPages:numPages block:^(UIView *view) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    label.text = @"Survival";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
  }];
}

#pragma mark - Scene Control

-(void)playAsteroids {
  [((TauGameAppDelegate*)[UIApplication sharedApplication].delegate) showSceneController];
}

-(void)play {
  [self playAsteroids];
}

#pragma mark - View Lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  // Warning, some nastiness ahead. We're initializing in Portrait, displaying in Landscape, so 
  // heights and widths are reversed. Autoresizing magic takes care of most of it.
  
  // Setup some helper information
  CGRect windowBounds = [[UIScreen mainScreen] bounds];
  float width = windowBounds.size.width;
  float height = windowBounds.size.height;
  int numPages = 0;
  
  // Setup top level view
  UIView *view = [[UIView alloc] initWithFrame:windowBounds];
  self.view = view;
  
  // Setup background
  // TODO: Device specific background images as an optimization?
  // TODO: Unstretch image & make a new image that reflects the motif of the game!
  UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:windowBounds];
  UIImage *background = [UIImage imageNamed:@"main-menu-background.jpg"];
  [background resizableImageWithCapInsets:UIEdgeInsetsZero];
  backgroundView.image = background;
  backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [view addSubview:backgroundView];
  
  // Setup scroll view
  scrollView = [[UIScrollView alloc] init];
  scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  scrollView.clipsToBounds = YES;
  scrollView.scrollEnabled = YES;
  scrollView.pagingEnabled = YES;
  scrollView.delegate = self;
  scrollView.frame = windowBounds;
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  scrollView.showsHorizontalScrollIndicator = NO;
  
  // Setup scene displays
  [self setupAsteroidsWithWidth:height height:width numPages:numPages++];
  [self setupSpaceInvadersWithWidth:height height:width numPages:numPages++];
  [self setupSurvivalWithWidth:height height:width numPages:numPages++];
  
  // Finish up scroll view
  scrollView.contentSize = CGSizeMake(numPages * height, width);
  [view addSubview:scrollView];
  
  // Setup page control
  pageControl = [[UIPageControl alloc] init];
  pageControl.numberOfPages = numPages;
  CGSize pageControlSize = [pageControl sizeForNumberOfPages:numPages];
  pageControl.frame = CGRectMake(0, width-pageControlSize.height, pageControlSize.width, pageControlSize.height);
  pageControl.center = CGPointMake(height/2, width-pageControlSize.width/2);
  pageControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
  [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
  [view addSubview:pageControl];
  
  // Setup play button
  UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
  playButton.frame = CGRectMake(0,0,150,50);
  playButton.center = CGPointMake(height/2, width-65);
  playButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
  [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
  [view addSubview:playButton];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Paging Controls

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
  if (pageControlIsChangingPage) {
    return;
  }
  
  // We switch page at 50% across
  CGFloat pageWidth = scrollView.frame.size.width;
  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
  pageControlIsChangingPage = NO;
}

- (IBAction)changePage:(id)sender 
{
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * pageControl.currentPage;
  frame.origin.y = 0;
	
  [scrollView scrollRectToVisible:frame animated:YES];
  
	// When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
  pageControlIsChangingPage = YES;
}


@end
