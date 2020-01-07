//
//  main.h
//  MetalExample
//
//  Created by Brent on 6/1/20.
//  Copyright © 2020 James Hughes. All rights reserved.
//

#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import <UIKit/UIKit.h>


@interface MetalView : UIView
{
  id<MTLDevice> m_mtlDevice;
  id<MTLCommandQueue> m_mtlCommandQueue;
  id<MTLRenderPipelineState> m_mtlPipelineState;
}
@property (nonatomic, strong) CAMetalLayer* metalLayer;
@property (nonatomic, strong) CADisplayLink* displayLink;

- (int) renderInit;
- (void) renderDestroy;

@end
