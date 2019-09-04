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
    let modelScale: Float = 1.4

    var faces: [Face2D] = []
    var timer: Timer!
    var lastLineNode: [SCNNode] = []
    //1. Variable To Store Our MainContentHolder
    var activeNode = SCNNode()
    
    public var model: String = ""
    //3. Our Dyanmic Scenes
    var modelRoot: SCNNode!
    var maxFaceWidth: Float = 0

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

        self.modelRoot = modelRoot
        
        activeNode.addChildNode(modelRoot)
        
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
                let faceContour = face.getFaceContour()
                let faceWidth = Float(distance(faceContour[0], faceContour[faceContour.count - 1]))
                if faceWidth > maxFaceWidth * 0.9 || faceWidth < maxFaceWidth * 0.8 {
                    maxFaceWidth = faceWidth
                }
                activeNode.position = facePosition
                activeNode.position.y += face.getFaceSize() * 1.1
                ModelsManager.sharedInstance.models.append(activeNode)
                activeNode.scale = SCNVector3(face.getFaceSize() * maxFaceWidth * modelScale,
                                                face.getFaceSize() * modelScale,
                                                face.getFaceSize() * maxFaceWidth * modelScale)
                activeNode.eulerAngles = SCNVector3(x: 0, y: Float(truncating: face.getYaw()!), z: 0)

                self.previewView.scene.rootNode.addChildNode(activeNode)

                index += 1
            }

        }
    }

    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
}
