//
//  FaceDetectViewController.swift
//  ArWig
//
//  Created by Esteban Arrúa on 11/9/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Vision
import ARKit

class FaceDetectViewController: UIViewController {

    // MARK: - Outlets

  
    @IBOutlet weak var previewView: ARSCNView!
    

    // MARK: - Properties
    let faceProportion: Float = 1.5
    let modelScale: Float = 1

    var faces: [Face2D] = []
    var timer: Timer!
    var lastLineNode: [SCNNode] = []
    //1. Variable To Store Our MainContentHolder
    var activeNode = SCNNode()
    
    public var model: String = ""
    //3. Our Dyanmic Scenes
    var modelRoot: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScenes()
    
        let scene = SCNScene()
        previewView.scene = scene
        previewView.automaticallyUpdatesLighting = true
        //previewView.autoenablesDefaultLighting = true
        
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light?.type = .directional
        
        previewView.scene.rootNode.addChildNode(spotLight)

        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] _ in
            self?.faceTracking()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        previewView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        previewView.session.pause()
    }

    
    // MARK: - Setup Scenes
    func setupScenes() {

        guard let urlB = Bundle.main.url(forResource: model, withExtension: "usdz", subdirectory: "art.scnassets") else { fatalError() }
        let activeScene = try! SCNScene(url: urlB, options: nil)
        let modelRoot = activeScene.rootNode
        modelRoot.eulerAngles = SCNVector3(0, 3, 0)

        self.modelRoot = modelRoot
        
    }

   /* func toggleScenes() {

         /*//1. If The 1st Model Is Displayed Then Remove It & Add The 2nd Model
        if activeNode.childNodes.contains(modelRootA) || !initialModelSet {
            initialModelSet = true
            print("CZAPKA")
            modelRootA.removeFromParentNode()
            activeNode.addChildNode(modelRootB)
            return
        }
        
        //2. If The 2nd Model Is Displayed Then Remove It & Add The 1st Modle
        if activeNode.childNodes.contains(modelRootB){
            print("CYLINDER")
            modelRootB.removeFromParentNode()
            activeNode.addChildNode(modelRootA)
            return
        }
        
        if activeNode.childNodes.contains(modelRootA) || !initialModelSet {
            initialModelSet = true
            print("Beanie")
            modelRootA.removeFromParentNode()
            activeNode.addChildNode(modelRootC)
            return
        } */

        print(modelsIndex)

        if modelsIndex < models.count {
            activeNode.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            activeNode.addChildNode(models[modelsIndex])
            modelsIndex += 1
            if modelsIndex > models.count-1 {
                modelsIndex = 0
            }
            return
        }

    }

    @objc
    func leftSwipe() {
        toggleScenes()
        print("TOGGLE")
    }

    @objc
    func rightSwipe() {
        toggleScenes()
        print("TOGGLE")
    } */

    // MARK: - FACE AR TRACKING
    
    fileprivate func faceTracking() {
        guard let frame = previewView.session.currentFrame else {
            return
        }

        let pixelBuffer = frame.capturedImage

        if case .normal = frame.camera.trackingState {
            let bondingBoxes = FaceTrackingManager.sharedInstance.trackFaces(pixelBuffer: pixelBuffer)

            let resolution = CGSize(width: previewView.bounds.width, height: previewView.bounds.height)
            faces = FaceTrackingManager.sharedInstance.getFaces(bondingBoxes, resolution: resolution)

            var index = 0
            for face2D in self.faces {
                if let face3D = Face3D(withFace2D: face2D, view: self.previewView) {
                    FaceManager.sharedInstance.addNewFace(face2D: face2D, face3D: face3D)
                }
            }

            FaceManager.sharedInstance.deleteUnusedFaces()
            for face in FaceManager.sharedInstance.lastFaces {
                let facePosition = face.getPosition()
                //let hattrickNode = ModelsManager.sharedInstance.getNode(forIndex: index, model: model)
                activeNode.position = facePosition
                activeNode.position.y += face.getFaceSize() * 1.1
                ModelsManager.sharedInstance.models.append(activeNode)
                //hattrickNode.infiniteRotation(x: 0, y: Float.pi, z: 0, duration: 5.0)
//                    let move = SCNAction.moveBy(x: CGFloat(facePosition.x - hattrickNode.position.x), y: 0,
//                        z: CGFloat(facePosition.z - hattrickNode.position.z), duration: 0.05)
//                    hattrickNode.runAction(move)
                activeNode.scale = SCNVector3(face.getFaceSize() * modelScale,
                                                face.getFaceSize() * modelScale,
                                                face.getFaceSize() * modelScale)
                activeNode.eulerAngles = SCNVector3(x: 0, y: Float(truncating: face.getYaw()!), z: 0)

                self.previewView.scene.rootNode.addChildNode(activeNode)

                index += 1
            }

        }
    }

}
