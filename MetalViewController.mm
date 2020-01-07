//
//  MetalViewAppDelegate.m
//  MetalExample
//
//  Created by Brent on 6/1/20.
//  Copyright © 2020 James Hughes. All rights reserved.
//

#import "MetalViewController.h"

#import "MetalView.h"

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

MetalViewController* g_MetalViewController;

@implementation MetalViewController

@synthesize m_metalView;

- (instancetype)init
{
  self = [super init];
  if (!self)
    return nil;

  g_MetalViewController = self;
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Add in our metal view.
  CGRect contentSize = self.view.bounds;
  m_metalView = [[MetalView alloc]  initWithFrame:contentSize];

  m_metalView.bounds = self.view.bounds;
  [self.view addSubview:m_metalView];
}

@end
