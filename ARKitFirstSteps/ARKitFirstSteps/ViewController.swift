//
//  ViewController.swift
//  ARKitFirstSteps
//
//  Created by Douglas Barreto on 05/09/17.
//  Copyright © 2017 Douglas. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNNodeRendererDelegate {

    @IBOutlet var sceneView: ARSCNView!

    
    var velocity = SCNVector3(0,0,0.1)
    var geometry: SCNGeometry!
    var geometryNodes = [SCNNode]()
    let scene = SCNScene()
    var currentPosition: matrix_float4x4 {
        return sceneView.session.currentFrame!.camera.transform
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGeometry()
        setupScene()
    }
    
    func setupGeometry() {
        geometry = createSphere()
    }
    
    func setupScene() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = scene
        sceneView.preferredFramesPerSecond = 60
        sceneView.autoenablesDefaultLighting = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapScreen))
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func onTapScreen() {
        addNodeBox()
    }
    
    func addNodeBox() {
        let node = SCNNode(geometry: geometry)
        var translation = matrix_identity_float4x4
        node.position = SCNVector3(0, 0, 0)
        translation.columns.3.z = -0.2
        node.simdTransform = matrix_multiply(currentPosition, translation)
        
        geometryNodes.append(node)
        scene.rootNode.addChildNode(node)
    }
    
    func createSphere() -> SCNSphere {
        return SCNSphere(radius: 0.1)
    }
    
    func createBox() -> SCNBox {
        return SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        geometryNodes.forEach { geometryNode in
            updateNodePosition(geometryNode)
        }
    }
    
    func updateNodePosition(_ node: SCNNode ) {
        let lastPosition = node.position
        let newPosition = SCNVector3(lastPosition.x, lastPosition.y, lastPosition.z - velocity.z)
        node.position = newPosition
        print(node.position)
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
