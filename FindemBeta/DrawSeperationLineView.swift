//
//  DrawSeperationLineView.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 25/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class DrawSeperationLineView: UIView {
    
    override func drawRect(rect: CGRect) {
        // First Line
        let firstPath: UIBezierPath = UIBezierPath()
        firstPath.moveToPoint(CGPointMake(self.frame.width/2, self.frame.height/2))
        firstPath.addLineToPoint(CGPointMake(0, self.frame.height/2))
        // Create first CAShape Layer
        let firstPathLayer: CAShapeLayer = CAShapeLayer()
        firstPathLayer.frame = self.bounds
        firstPathLayer.path = firstPath.CGPath
        firstPathLayer.strokeColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0).CGColor
        firstPathLayer.fillColor = nil
        firstPathLayer.lineWidth = 4.0
        firstPathLayer.lineJoin = kCALineJoinBevel
        
        // Add first layer to views layer
        self.layer.addSublayer(firstPathLayer)
        
        // First Basic Animation
        let firstPathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        firstPathAnimation.duration = 2.0
        firstPathAnimation.fromValue = NSNumber(float: 0.0)
        firstPathAnimation.toValue = NSNumber(float:2.0)
        
        // Add First Animation
        firstPathLayer.addAnimation(firstPathAnimation, forKey: "strokeEnd")
        
        // Second Line
        let secondPath: UIBezierPath = UIBezierPath()
        secondPath.moveToPoint(CGPointMake(self.frame.width/2, self.frame.height/2))
        secondPath.addLineToPoint(CGPointMake(self.frame.width, self.frame.height/2))
        // Create second CAShape Layer
        let secondPathLayer: CAShapeLayer = CAShapeLayer()
        secondPathLayer.frame = self.bounds
        secondPathLayer.path = secondPath.CGPath
        secondPathLayer.strokeColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0).CGColor
        secondPathLayer.fillColor = nil
        secondPathLayer.lineWidth = 4.0
        secondPathLayer.lineJoin = kCALineJoinBevel
        
        // Add second layer to views layer
        self.layer.addSublayer(secondPathLayer)
        
        // Second Basic Animation
        let secondPathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        secondPathAnimation.duration = 2.0
        secondPathAnimation.fromValue = NSNumber(float: 0.0)
        secondPathAnimation.toValue = NSNumber(float:2.0)
        
        // Add First Animation
        secondPathLayer.addAnimation(secondPathAnimation, forKey: "strokeEnd")
    }
    
}
