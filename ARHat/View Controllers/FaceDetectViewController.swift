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
    var model: String = "cylinder"
    
    // MARK: - Setup
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc
    func leftSwipe() {
        if model == "hat" {
            model = "cylinder"
        } else {
            model = "hat"
        }
        print(model)
    }
    
    @objc
    func rightSwipe() {
        if model == "hat" {
            model = "cylinder"
        } else {
            model = "hat"
        }
        print(model)
    }
    
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
                let hattrickNode = ModelsManager.sharedInstance.getNode(forIndex: index, model: model)
                if hattrickNode.parent == nil {
                    hattrickNode.position = facePosition
                    hattrickNode.position.y += face.getFaceSize() * 1.1
                    //hattrickNode.infiniteRotation(x: 0, y: Float.pi, z: 0, duration: 5.0)
                } else {
//                    let move = SCNAction.moveBy(x: CGFloat(facePosition.x - hattrickNode.position.x), y: 0,
//                        z: CGFloat(facePosition.z - hattrickNode.position.z), duration: 0.05)
//                    hattrickNode.runAction(move)
                }
                hattrickNode.scale = SCNVector3(face.getFaceSize() * modelScale,
                                                face.getFaceSize() * modelScale,
                                                face.getFaceSize() * modelScale)
                
                self.previewView.scene.rootNode.addChildNode(hattrickNode)
                
                index += 1
            }
            
            let releasedNodes = ModelsManager.sharedInstance.releaseNodes(fromIndex: index)
            for node in releasedNodes {
                node.removeAllActions()
            }
        }
    }
    
}
