//
//  SettingsViewController.swift
//  YogaTimer
//
//  Created by Sam Lerner on 8/17/16.
//  Copyright © 2016 Sam Lerner. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var randomSwitch: UISwitch!
    @IBOutlet weak var holdSlider: UISlider!
    @IBOutlet weak var changeSlider: UISlider!
    
    var random = false
    var holdTime = 30
    var changeTime = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomSwitch.isOn = random
        changeSlider.value = Float(changeTime)
        holdSlider.value = Float(holdTime)
        
        randomSwitch.addTarget(self, action: #selector(SettingsViewController.toggleRandom), for: .valueChanged)
        holdSlider.addTarget(self, action: #selector(SettingsViewController.holdChange), for: .valueChanged)
        changeSlider.addTarget(self, action: #selector(SettingsViewController.changeChange), for: .valueChanged)
    }
    
    func toggleRandom() {
        random = !random
        ViewController.randomize = random
    }
    
    func holdChange() {
        ViewController.holdTime = Int(holdSlider.value)
    }
    
    func changeChange() {
        ViewController.changeTime = Int(changeSlider.value)
    }

    @IBAction func finish(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
