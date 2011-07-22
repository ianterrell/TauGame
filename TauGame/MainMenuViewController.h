//
//  MainMenuViewController.h
//  TauGame
//
//  Created by Ian Terrell on 7/22/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController <UIScrollViewDelegate> {
  UIScrollView *scrollView;
  UIPageControl *pageControl;
  BOOL pageControlIsChangingPage;
}

@end
