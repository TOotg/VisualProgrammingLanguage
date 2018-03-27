//
//  DisplayNodeSocket.swift
//  VPL
//
//  Created by Nathan Flurry on 3/13/18.
//  Copyright © 2018 Nathan Flurry. All rights reserved.
//

import UIKit

enum DisplayNodeSocketType {
    case controlFlow(NodeTrigger), dataFlow(NodeValue)
    
    var socketColor: UIColor {
        switch self {
        case .controlFlow(_):
            return UIColor.orange
        case .dataFlow(_):
            return UIColor.blue
        }
    }
}

class DisplayNodeSocket: UIView {
    var type: DisplayNodeSocketType
    
    weak var node: DisplayNode?
    
    var draggingTarget: CGPoint?
    
    init(frame: CGRect, type: DisplayNodeSocketType, node: DisplayNode) {
        self.type = type
        self.node = node
        
        super.init(frame: frame)
        
        backgroundColor = type.socketColor
        
        // Add drag gesture
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(sender:)))
        addGestureRecognizer(dragGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panned(sender: UIPanGestureRecognizer) {
        guard let node = node, let canvas = node.canvas else {
            print("Missing node or canvas for socket.")
            return
        }
        
        // Update the dragging to position
        if sender.state == .began || sender.state == .changed {
            // Set the translation in this view; otherwise, it will start at 0
            // which is not what we want
            if draggingTarget == nil {
                sender.setTranslation(sender.location(ofTouch: 0, in: self), in: self)
            }
            
            // Save the translation
            draggingTarget = sender.translation(in: self)
        } else {
            draggingTarget = nil
        }
        
        // Notify the canvas the node was updated
        canvas.updatedNode(node: node)
    }
}