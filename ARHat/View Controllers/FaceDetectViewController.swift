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


    @IBAction func ARSwitch(_ sender: UIButton) {
        if previewView.session.configuration == ARWorldTrackingConfiguration() {
            guard ARFaceTrackingConfiguration.isSupported else {
                let alert = UIAlertController(title: "AR ERROR", message: "Face Tracking not supported", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            let faceConfiguration = ARFaceTrackingConfiguration()
            faceConfiguration.isLightEstimationEnabled = true
            previewView.session.run(faceConfiguration, options: [.resetTracking, .removeExistingAnchors])
        } else {
            previewView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    @IBOutlet weak var previewView: ARSCNView!
    
    
    // MARK: - Properties
    let faceProportion: Float = 1.5
    let modelScale: Float = 1.4
    
    //FaceAR Properties
    var contentNode: SCNNode?
    var occlusionNode: SCNNode!
    let oculusion = FaceOcclusionOverlay()
    
    var currentFaceAnchor: ARFaceAnchor?

    var faces: [Face2D] = []
    var timer: Timer!
    var lastLineNode: [SCNNode] = []
    //1. Variable To Store Our MainContentHolder
    var activeNode = SCNNode()
    
    public var model: String = ""
    public var name: String = ""
    public var scale: SCNVector3!
    public var position: SCNVector3!
    public var tilt: SCNVector3!
    //3. Our Dyanmic Scenes
    var modelRoot: SCNNode!
    var maxFaceWidth: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = name
        
        setupScenes()
        
        let scene = SCNScene()
        previewView.delegate = self
        previewView.scene = scene
        previewView.automaticallyUpdatesLighting = true
        //previewView.autoenablesDefaultLighting = true
        
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light?.type = .directional
        
        previewView.scene.rootNode.addChildNode(spotLight)
        

//        //timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] _ in
//            self?.faceTracking()
//        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARFaceTrackingConfiguration()
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
    /*
    fileprivate func faceTracking() {
        
        
        if previewView.session.configuration == ARWorldTrackingConfiguration() {
            
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
        } else if previewView.session.configuration == ARFaceTrackingConfiguration() {
            return
        }
    } */

    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
}

extension FaceDetectViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        currentFaceAnchor = faceAnchor
        
        // If this is the first time with this anchor, get the controller to create content.
        // Otherwise (switching content), will change content when setting `selectedVirtualContent`.
        if node.childNodes.isEmpty, let contentNode = oculusion.renderer(renderer, nodeFor: faceAnchor, activenode: activeNode,scale: scale, position: position, tilt: tilt) {
            node.addChildNode(contentNode)
        }
    }
    
    /// - Tag: ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor == currentFaceAnchor,
            let contentNode = oculusion.contentNode,
            contentNode.parent == node
            else { return }
        
        oculusion.renderer(renderer, didUpdate: contentNode, for: anchor)
    }
}

