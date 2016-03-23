//
//  LoadingView.swift
//  Load
//
//  Created by Kaveh on 3/20/16.
//  Copyright © 2016 treepi. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    class func addTo(view:UIView) {
        let loadingView = LoadingView(frame: CGRect(x: view.frame.size.width/2-50, y: view.frame.size.height/2-50, width: 100, height: 100))
        view.addSubview(loadingView)
    }
    
    class func removeFrom(view:UIView) {
        for thisView in view.subviews {
            if thisView.isKindOfClass(LoadingView) {
                thisView.removeFromSuperview()
            }
        }
    }
    
    func rotateLayerInfinite(layer: CALayer) {
        let rotation: CABasicAnimation
        rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = (2 * M_PI)
        rotation.duration = 1.8
        rotation.repeatCount = Float.infinity
        layer.removeAllAnimations()
        layer.addAnimation(rotation, forKey: "Spin")
    }
    
    func rotateSecondLayerInfinite(layer: CALayer) {
        let rotation: CABasicAnimation
        rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = (2 * M_PI)
        rotation.toValue = 0
        rotation.duration = 1.8
        rotation.repeatCount = Float.infinity
        layer.removeAllAnimations()
        layer.addAnimation(rotation, forKey: "Spin")
    }

    func blinkLayerInfinite(layer: CALayer) {
        let blink: CAKeyframeAnimation
        blink = CAKeyframeAnimation(keyPath: "opacity")
        blink.values = [0.1,0.9,0.1]
        blink.duration = 1.8
        blink.repeatCount = Float.infinity
        layer.removeAllAnimations()
        layer.addAnimation(blink, forKey: "Blink")
    }
    
    func applyBlur() {
    
        let blur = UIBlurEffect(style: .Light)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.bounds
        let vibrancy = UIVibrancyEffect(forBlurEffect: blur)
        let vibrantView = UIVisualEffectView(effect: vibrancy)
        vibrantView.frame = self.bounds
        effectView.backgroundColor = UIColor.clearColor()
        effectView.layer.cornerRadius = self.frame.size.width/7
        effectView.layer.opacity = 0.9
        vibrantView.layer.cornerRadius = self.frame.size.width/7
        vibrantView.layer.masksToBounds = true
        effectView.layer.masksToBounds = true
        addSubview(effectView)
        addSubview(vibrantView)
    }
    
    func commonInit() {
        applyBlur()
        let imageView = UIImageView(frame: CGRect(x: self.frame.size.width/2-20, y: self.frame.size.height/2-30, width: 40, height: 40))
        imageView.image = UIImage(named: "half")
        addSubview(imageView)
        let secondImageView = UIImageView(frame: CGRect(x: self.frame.size.width/2-15, y: self.frame.size.height/2-25, width: 30, height: 30))
        secondImageView.image = UIImage(named: "half-pink")
        addSubview(secondImageView)
        let label = UILabel(frame: CGRect(x: self.frame.size.width/2-50, y: self.frame.size.height/2+8, width: 100, height: 30))
        label.text = "Loading"
        label.font = UIFont.systemFontOfSize(16, weight: UIFontWeightThin)
        label.textAlignment = NSTextAlignment.Center;
        label.textColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0)
        addSubview(label)
        
        rotateLayerInfinite(imageView.layer)
        rotateSecondLayerInfinite(secondImageView.layer)
        blinkLayerInfinite(label.layer)
        
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
}
