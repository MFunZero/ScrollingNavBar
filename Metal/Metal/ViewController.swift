//
//  ViewController.swift
//  Metal
//
//  Created by suze on 15/10/20.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit
import QuartzCore
class ViewController: UIViewController {

    var timer: CADisplayLink! = nil

    var commandQueue: MTLCommandQueue! = nil
    var pipelineState:MTLRenderPipelinneState! = nil
    
    var vertextBuffer:MTLBuffer! = nil
    var metalLayer:CAMetalLayer! = nil
    var device:MTLDevice! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        device = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .BGRA8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        
        let vertextData:[Float] = [
        0.0,1.0,0.0,
        -1.0,-1.0,0.0,
        1.0,-1.0,0.0]
        let dataSize = vertextData.count * sizeofValue(vertextData[0])
        vertextBuffer = device.newBufferWithBytes(vertextData,length: dataSize, options:nil)
        
        
        let defaultLibrary = device.newDefaultLibrara()
        let fragmentProgram = defaultLibrary.newFunctionWithName("basic_fragment")
        let vertexProgram = defaultLibrary.newFunctionWithName("basic_vertex")
        
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
        // 3
        var pipelineError : NSError?
        pipelineState = device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor, error: &pipelineError)
        if !pipelineState {
            print("Failed to create pipeline state, error \(pipelineError)")
        }
        
        
        
        commandQueue = device.newCommandQueue()
        
        
        
        
        timer = CADisplayLink(target: self, selector: Selector("gameloop"))
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func render() {
        var drawable = metalLayer.nextDrawable()
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        let commandBuffer = commandQueue.commandBuffer()
        let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
        renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()
        
    }
    
    func gameloop() {
        autoreleasepool {
            self.render()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

