//
//  ViewController.swift
//  LineNode
//
//  Created by Minhaz Panara on 26/09/17.
//  Copyright © 2017 Minhaz Panara. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        self.setupScene()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // setup scene
    func setupScene()
    {
        // set delegate - ARSCNViewDelegate
        self.sceneView.delegate = self
        
        // showing statistics (fps, timing info)
        self.sceneView.showsStatistics = true
        self.sceneView.autoenablesDefaultLighting = true
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }
        
        // debug points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // create new scene
        let scene = SCNScene()
        self.sceneView.scene = scene
        
        let v1 = SCNVector3Zero
        let v2 = SCNVector3Make(1, 1, 1)
        
        
        let mat = SCNMaterial()
        
        mat.diffuse.contents  = UIColor.cyan
        mat.specular.contents = UIColor.green
        
        let lineNode = LineNode(v1: v1, v2: v2, material: [mat])
        self.sceneView.scene.rootNode.addChildNode(lineNode)
    }
    
    // MARK: - ARSCNViewDelegate
    
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

class LineNode: SCNNode
{
    init(
        v1: SCNVector3,  // where line starts
        v2: SCNVector3,  // where line ends
        material: [SCNMaterial] )  // any material.
    {
        super.init()
        let  height1 = self.distanceBetweenPoints2(A: v1, B: v2) as CGFloat //v1.distance(v2)
        
        position = v1
        
        let ndV2 = SCNNode()
        
        ndV2.position = v2
        
        let ndZAlign = SCNNode()
        ndZAlign.eulerAngles.x = Float.pi/2
        
        let cylgeo = SCNBox(width: 0.02, height: height1, length: 0.001, chamferRadius: 0)
        cylgeo.materials = material
        
        let ndCylinder = SCNNode(geometry: cylgeo )
        ndCylinder.position.y = Float(-height1/2) + 0.001
        ndZAlign.addChildNode(ndCylinder)
        
        addChildNode(ndZAlign)
        
        constraints = [SCNLookAtConstraint(target: ndV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func distanceBetweenPoints2(A: SCNVector3, B: SCNVector3) -> CGFloat {
        let l = sqrt(
            (A.x - B.x) * (A.x - B.x)
                +   (A.y - B.y) * (A.y - B.y)
                +   (A.z - B.z) * (A.z - B.z)
        )
        return CGFloat(l)
    }
}
