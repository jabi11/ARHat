//
//  ModelsManager.swift
//  ARWig
//
//  Created by Esteban Arrúa on 11/20/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import ARKit
import SceneKit.ModelIO

class ModelsManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = ModelsManager()
    
    // MARK: - Properties
    
    private var models: [SCNNode] = []
    
    func getNode(forIndex index: Int, model: String) -> SCNNode {
        if index >= models.count {
            
            guard let cylinderScene = SCNScene(named: "art.scnassets/blsmpht2.dae") else {
                fatalError("Fail hattrickScene load.")
            }
            
            guard let cylinderNode = cylinderScene.rootNode.childNode(withName: "Cylinder", recursively: true) else {
                fatalError("Hattrick node doesn't exist.")
            }
            
            cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "check")
            cylinderNode.scale = SCNVector3(1, 0.05, 1)
            
            guard let hatScene = SCNScene(named: "art.scnassets/pink_hat.scn") else {
                fatalError("Fail hattrickScene load.")
            }
            
            guard let hatNode = hatScene.rootNode.childNode(withName: "Object_1", recursively: true) else {
                fatalError("Hattrick node doesn't exist.")
            }
            
            hatNode.localRotate(by: SCNQuaternion(x: 0, y: 0.7071, z: 0, w: 0.7071))
            if model == "hat" {
                hatNode.removeFromParentNode()
                models.append(hatNode)
                return hatNode
            }
            if model == "cylinder" {
                cylinderNode.removeFromParentNode()
                models.append(cylinderNode)
            }
            return cylinderNode
        } else {
            return models[index]
        }
    }
    
    func releaseNodes(fromIndex index: Int) -> [SCNNode] {
        var nodes: [SCNNode] = []
        
        for i in index..<models.count {
            models[i].removeFromParentNode()
            nodes.append(models[i])
        }
        
        return nodes
    }
    
}
