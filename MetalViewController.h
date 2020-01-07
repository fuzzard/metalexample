//
//  MetalViewAppDelegate.m
//  MetalExample
//
//  Created by Brent on 6/1/20.
//  Copyright © 2020 James Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

#import "MetalView.h"

@interface MetalViewController : UIViewController
@property (nonatomic, strong) MetalView* m_metalView;
@end

extern MetalViewController* g_MetalViewController;
