//
//  PauseView.swift
//  YogaTimer
//
//  Created by Sam Lerner on 8/21/16.
//  Copyright © 2016 Sam Lerner. All rights reserved.
//

import UIKit

@IBDesignable
class PauseView: UIView {
    
    var fillColor = UIColor(red: 104.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0)

    override func draw(_ rect: CGRect) {
        let background = UIBezierPath(ovalIn: rect)
        UIColor.clear.setFill()
        background.fill()
        
        let stick1 = UIBezierPath(rect: CGRect(x: 3*rect.width/10, y: rect.height/4, width: rect.width/7, height: 3*rect.height/6))
        let stick2 = UIBezierPath(rect: CGRect(x: 5.5*rect.width/10, y: rect.height/4, width: rect.width/7, height: 3*rect.height/6))
        
        UIColor.blue.setFill()
        stick1.fill()
        stick2.fill()
    }

}
