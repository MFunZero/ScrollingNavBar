//
//  GameViewController.swift
//  game
//
//  Created by suze on 15/10/20.
//  Copyright (c) 2015年 suze. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var geometryNode: SCNNode = SCNNode()
    // Gestures
    var currentAngle: Float = 0.0
    @IBOutlet var senceView: SCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewDidAppear(animated: Bool) {
        sceneSetup()
    }
    func sceneSetup() {
        // 实例化一个空的SCNScene类，接下来要用它做更多的事
        let scene = SCNScene()
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLightTypeOmni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(cameraNode)
        // 定义一个SCNBox类的几何实例然后创建盒子，并将其作为根节点的子节点，根节点就是scene
        let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
        let boxNode = SCNNode(geometry: boxGeometry)
        scene.rootNode.addChildNode(boxNode)
        
        geometryNode = boxNode
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "panGesture:")
        self.senceView.addGestureRecognizer(panRecognizer)
        
        self.senceView.scene = scene
       // self.senceView.autoenablesDefaultLighting = true
        //self.senceView.allowsCameraControl = true

    }
    func panGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(sender.view!)
        var newAngle = (Float)(translation.x)*(Float)(M_PI)/180.0
        newAngle += currentAngle
        
        geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        
        if(sender.state == UIGestureRecognizerState.Ended) {
            currentAngle = newAngle  }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
