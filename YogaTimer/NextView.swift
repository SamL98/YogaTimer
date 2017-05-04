//
//  NextView.swift
//  YogaTimer
//
//  Created by Sam Lerner on 8/21/16.
//  Copyright © 2016 Sam Lerner. All rights reserved.
//

import UIKit

class NextView: UIView {
    
    var fillColor = UIColor(red: 104.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0)

    override func draw(_ rect: CGRect) {
        let background = UIBezierPath(ovalIn: rect)
        UIColor.clear.setFill()
        background.fill()
        
        let stick = UIBezierPath(rect: CGRect(x: 3*rect.width/10, y: rect.height/4, width: rect.width/7, height: rect.height/2))
        let arrow = UIBezierPath()
        
        arrow.move(to: CGPoint(x: 5.5*rect.width/10, y: rect.height/4))
        arrow.addLine(to: CGPoint(x: 5.5*rect.width/10, y: 3*rect.height/4))
        arrow.addLine(to: CGPoint(x: 8*rect.width/10, y: rect.height/2))
        arrow.close()
        
        UIColor.black.setFill()
        stick.fill()
        arrow.fill()
    }

}
