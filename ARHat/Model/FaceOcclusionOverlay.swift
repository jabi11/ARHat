/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Demonstrates how to simulate occlusion of virtual content by the real-world face.
*/

import ARKit
import SceneKit

class FaceOcclusionOverlay: NSObject {
    
    var contentNode: SCNNode?
    
    var occlusionNode: SCNNode!
    
    /// - Tag: OcclusionMaterial
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor, activenode: SCNNode) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }

        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
        #else
        /*
         Write depth but not color and render before other objects.
         This causes the geometry to occlude other SceneKit content
         while showing the camera view beneath, creating the illusion
         that real-world objects are obscuring virtual 3D objects.
         */
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        faceGeometry.firstMaterial!.colorBufferWriteMask = []
        occlusionNode = SCNNode(geometry: faceGeometry)
        occlusionNode.renderingOrder = -1

        // Add 3D asset positioned to appear as "glasses".
        let faceOverlayContent = activenode
        faceOverlayContent.scale = SCNVector3(x: 0.17 , y: 0.17, z: 0.2)
        faceOverlayContent.position = SCNVector3(x: 0, y: 0.13, z: -0.035)
        faceOverlayContent.eulerAngles = SCNVector3(x: -0.2, y: 0, z: 0)

        contentNode = SCNNode()
        contentNode!.addChildNode(occlusionNode)
        contentNode!.addChildNode(faceOverlayContent)
        #endif
        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = occlusionNode.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }

}
