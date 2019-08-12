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

    public var models: [SCNNode] = []

    func getNode(forIndex index: Int) -> SCNNode {
        if index >= models.count {
            return models[index]

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
