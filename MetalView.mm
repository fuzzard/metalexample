//
//  MetalView.m
//  MetalExample
//
//  Created by Brent on 6/1/20.
//  Copyright © 2020 James Hughes. All rights reserved.
//

#import "MetalView.h"

#import "MetalViewController.h"

#import <Foundation/Foundation.h>
#import <QuartzCore/CAMetalLayer.h>

@implementation MetalView

- (BOOL)acceptsFirstResponder 
{
  return YES;
}

+ (Class)layerClass
{
  return [CAMetalLayer class];
}

- (CAMetalLayer *)metalLayer
{
  return (CAMetalLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frameRect
{
  if ((self = [super initWithFrame:frameRect]))
  {
    if ([self renderInit] != EXIT_SUCCESS)
      return nil;

    self.metalLayer.device = m_mtlDevice;
    self.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    self.metalLayer.framebufferOnly = true; // Note: setting this will dissallow sampling and reading from texture.
    self.metalLayer.frame = frameRect;
    
    CGSize drawableSize = self.bounds.size;
    
    // Since drawable size is in pixels, we need to multiply by the scale to move from points to pixels
    CGFloat scale = UIScreen.mainScreen.scale;
    drawableSize.width *= scale;
    drawableSize.height *= scale;
    
    self.metalLayer.drawableSize = drawableSize;
  }
  return self;
}

- (void)dealloc
{
  [_displayLink invalidate];
  [self renderDestroy];
  [super dealloc];
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  if (self.superview)
  {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkDidFire:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
  }
  else
  {
    [self.displayLink invalidate];
    self.displayLink = nil;
  }
}

- (void)displayLinkDidFire:(CADisplayLink *)displayLink
{
  [self doRender];
}

- (void) doRender
{
  if (!g_MetalViewController.m_metalView.metalLayer)
  {
    NSLog(@"Warning: No metal layer, skipping render.\n");
    return;
  }

  id<CAMetalDrawable> drawable = [g_MetalViewController.m_metalView.metalLayer nextDrawable];
  id<MTLTexture> texture = drawable.texture;

  MTLRenderPassDescriptor* passDescriptor =
      [MTLRenderPassDescriptor renderPassDescriptor];
  passDescriptor.colorAttachments[0].texture = texture;
  passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
  passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
  passDescriptor.colorAttachments[0].clearColor =
      MTLClearColorMake(0.3f, 0.3f, 0.3f, 1.0f);

  id<MTLCommandBuffer> commandBuffer = [m_mtlCommandQueue commandBuffer];

  id<MTLRenderCommandEncoder> commandEncoder =
      [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];

  [commandEncoder setFrontFacingWinding:MTLWindingClockwise];
  [commandEncoder setCullMode:MTLCullModeNone];
  [commandEncoder setRenderPipelineState:m_mtlPipelineState];

  [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                     vertexStart:0
                     vertexCount:3];

  [commandEncoder endEncoding];

  [commandBuffer presentDrawable:drawable];
  [commandBuffer commit];
}

- (int) renderInit
{
  m_mtlDevice = MTLCreateSystemDefaultDevice();
  if (!m_mtlDevice)
  {
    NSLog(@"System does not support metal.\n");
    return EXIT_FAILURE;
  }

  m_mtlCommandQueue = [m_mtlDevice newCommandQueue];

  //------------------------------------------
  // Shader Compilation and Pipeline Creation
  //------------------------------------------

  NSError* err = nil;
  id<MTLLibrary> library = [m_mtlDevice newDefaultLibrary];

// Load shader from inline source
//  NSString* source = [[NSString alloc] initWithUTF8String:g_shaderCode];
//  MTLCompileOptions* compileOpts = [[MTLCompileOptions alloc] init];
//  compileOpts.languageVersion = MTLLanguageVersion2_0;
//  id<MTLLibrary> library = [m_mtlDevice newLibraryWithSource:source options:compileOpts error:&err];

  if (err)
  {
    NSLog(@"%@", err);
    return EXIT_FAILURE;
  }

  // Create pipeline state.
  MTLRenderPipelineDescriptor* pipelineDescriptor = [MTLRenderPipelineDescriptor new];
  pipelineDescriptor.vertexFunction = [library newFunctionWithName:@"render_vertex"];
  pipelineDescriptor.fragmentFunction = [library newFunctionWithName:@"render_fragment"];

  pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
  pipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormatInvalid;

  NSError* error = nil;
  m_mtlPipelineState = [m_mtlDevice newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
  if (!m_mtlPipelineState)
  {
    NSLog(@"Failed to create render pipeline state: %@", error);
  }

  return EXIT_SUCCESS;
}

- (void) renderDestroy
{
}


@end
