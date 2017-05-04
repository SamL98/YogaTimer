//
//  ArcLayer.swift
//  YogaTimer
//
//  Created by Sam Lerner on 8/17/16.
//  Copyright © 2016 Sam Lerner. All rights reserved.
//

import UIKit

class ArcLayer: CAShapeLayer {

    var parentFrame: CGRect!
    
    var holdTime = 30
    var changeTime = 10
    
    var timeLimit = 5
    var counter = 5
    
    enum Setting {
        case changingPosition, holdingPosition
    }
    
    override init() {
        super.init()
        fillColor = UIColor.clear.cgColor
        strokeColor = UIColor(red: 124.0/255.0, green: 222.0/255.0, blue: 117.0/255.0, alpha: 1.0).cgColor
        lineWidth = 7.0
        lineCap = kCALineCapRound
        lineJoin = kCALineJoinRound
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSettings(_ option: Setting) {
        switch option {
        case .changingPosition:
            strokeColor = UIColor(red: 61.0/255.0, green: 160.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
            timeLimit = changeTime
            counter = changeTime
        case .holdingPosition:
            strokeColor = UIColor(red: 124.0/255.0, green: 222.0/255.0, blue: 117.0/255.0, alpha: 1.0).cgColor
            timeLimit = holdTime
            counter = holdTime
        }
    }
    
    func initializePath() {
        path = createPath(timeLimit).cgPath
    }
    
    func createPath(_ time: Int) -> UIBezierPath {
        let center = CGPoint(x: self.parentFrame.width/2, y: self.parentFrame.height/2)
        
        let increment = 3.14/(Double(timeLimit)/2.0)
        let offset = Double(timeLimit-time)*(increment)
        let endAngle = CGFloat(-1.57 + offset)
        
        let arcPath = UIBezierPath()
        arcPath.addArc(withCenter: center, radius: self.parentFrame.width/2 - 20.0, startAngle: -CGFloat(1.57), endAngle: endAngle, clockwise: true)
        return arcPath
    }
    
    func animateArc() {
        counter -= 1
        let nextPath = createPath(counter).cgPath
        
        path = nextPath
        let stroke = CABasicAnimation(keyPath: "strokeEnd")
        stroke.fromValue = CGFloat(1.0 - 1.0/Double(timeLimit-counter))
        stroke.toValue = 1.0
        stroke.beginTime = 0.0
        stroke.duration = 0.325
        stroke.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        stroke.fillMode = kCAFillModeForwards
        stroke.isRemovedOnCompletion = false
        add(stroke, forKey: nil)
    }
    
}
