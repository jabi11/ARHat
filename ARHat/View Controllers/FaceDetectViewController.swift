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
import SceneKit.ModelIO

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

    //2. Variable To Determine Whether We Have Created Our Intial Content
    var initialModelSet = false

    //3. Our Dyanmic Scenes
    var modelRootA: SCNNode!
    var modelRootB: SCNNode!
    var modelRootC: SCNNode!

    var models: [SCNNode] = []
    var modelsIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScenes()
        toggleScenes()
        
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(FaceDetectViewController.leftSwipe))
        left.direction = .left
        self.previewView.addGestureRecognizer(left)

        let right = UISwipeGestureRecognizer(target: self, action: #selector(FaceDetectViewController.rightSwipe))
        right.direction = .right
        self.previewView.addGestureRecognizer(right)

        let scene = SCNScene()
        previewView.scene = scene
        previewView.automaticallyUpdatesLighting = true

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] _ in
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

        guard let activeSceneA = SCNScene(named: "art.scnassets/blsmpht2.dae"),
            let modelRootA = activeSceneA.rootNode.childNode(withName: "Cylinder", recursively: false)  else { return }

        modelRootA.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "check")
        modelRootA.scale = SCNVector3(1, 0.05, 1)

        self.modelRootA = modelRootA

        models.append(modelRootA)

        guard let activeSceneB = SCNScene(named: "art.scnassets/pink_hat.scn"),
            let modelRootB = activeSceneB.rootNode.childNode(withName: "Object_1", recursively: false)  else { return }

        self.modelRootB = modelRootB

        models.append(modelRootB)

        guard let url = Bundle.main.url(forResource: "Beanie", withExtension: "usdz", subdirectory: "art.scnassets") else { fatalError() }
        let mdlAsset = MDLAsset(url: url)
        let activeSceneC = SCNScene(mdlAsset: mdlAsset)
        let modelRootC = activeSceneC.rootNode.childNode(withName: "Object_1", recursively: true)
        modelRootC?.scale = SCNVector3(0.65, 0.65, 0.65)
        //modelRootC?.geometry?.firstMaterial?.diffuse.contents = UIColor.green

        self.modelRootC = modelRootC
        models.append(modelRootC!)

    }

    func toggleScenes() {

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
            print("ACTIVE NODE")
            print(activeNode)
            print("MODELS")
            print(models)
            modelsIndex += 1
            if modelsIndex > models.count-1 {
                modelsIndex = 0
            }
            return
        }/* else {
            modelsIndex = 0
            activeNode.enumerateChildNodes{ (node, stop) in
                node.removeFromParentNode()
            }
            activeNode.addChildNode(models[modelsIndex])
            print(activeNode)
            return
        }*/

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
    }

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

                self.previewView.scene.rootNode.addChildNode(activeNode)

                index += 1
            }

        }
    }

}
