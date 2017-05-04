//
//  ViewController.swift
//  YogaTimer
//
//  Created by Sam Lerner on 8/17/16.
//  Copyright © 2016 Sam Lerner. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var poseLabel: UILabel!
    @IBOutlet weak var poseImageView: UIImageView!
    @IBOutlet weak var pauseView: PauseView!
    var playView = PlayView()
    
    let arcLayer = ArcLayer()
    var timeLabel: UILabel!
    var timer: Timer!
    
    var isPaused = true
    var changingPosition = true
    static var randomize = false
    static var holdTime = 30
    static var changeTime = 10
    var shuffled = false
    var firstRound = true
    
    var player: AVAudioPlayer!
    
    var poses = ["Tree L", "Tree R", "Triangle L", "Warrior 2 L", "Side-angle L", "Knee-down low lunge R", "Triangle R", "Warrior 2 R", "Side-angle R", "Knee-down low lunge L", "Tabletop", "Tabletop L leg, R arm", "Tabletop R leg, L arm", "Down dog", "Plank", "Low cobra", "Down dog", "Plank", "Up dog", "Locust", "Bow", "L Left over R twist", "R leg over L twist", "Reverse Plank", "Bridge", "Corpse"]
    var index = -1 {
        didSet {
            if index >= 0 {
                poseLabel.text = poses[index]
            }
        }
    }
    
    var time = 10 {
        didSet {
            timeLabel.text = "\(time)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arcLayer.parentFrame = timerView.frame
        arcLayer.bounds = CGRect(x: 0, y: 0, width: timerView.bounds.width, height: timerView.bounds.height)
        arcLayer.position = CGPoint(x: timerView.frame.width/2, y: timerView.frame.height/2)
        
        arcLayer.initializePath()
        arcLayer.changeSettings(.changingPosition)
        
        timerView.layer.addSublayer(arcLayer)
        
        timeLabel = UILabel(frame: CGRect(x: timerView.frame.width/4, y: timerView.frame.height/4, width: timerView.frame.width/2, height: timerView.frame.height/2))
        timeLabel.textAlignment = .center
        timeLabel.text = "\(time)"
        
        timerView.addSubview(timeLabel)
        
        startButton.backgroundColor = UIColor.orange
        startButton.addTarget(self, action: #selector(ViewController.startWorkout), for: .touchUpInside)
        
        setUpViews()
        
        poseLabel.text = "Next up: \(poses[index+1])"
        
        timerView.isHidden = true
        poseLabel.isHidden = true
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        timer.fire()
        
        let path = Bundle.main.path(forResource: "56895^DING", ofType: "mp3")
        do {
            player = try AVAudioPlayer(data: Data(contentsOf: URL(fileURLWithPath: path!)))
            player.volume = 1.0
            player.prepareToPlay()
        } catch {
            print("unable to initialize audio player")
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        if startButton.isHidden {
//            startTimer()
//        }
//    }
    
    func setUpViews() {
        playView.backgroundColor = UIColor.clear
        playView.bounds = pauseView.bounds
        playView.frame = pauseView.frame
        view.insertSubview(playView, belowSubview: pauseView)
        
        playView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.startTimer)))
        pauseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.pauseTimer)))
    }
    
    func previousPose() {
        guard index != 0 else {
            return
        }
        
        index -= 1
        changingPosition = true
    }
    
    func nextPose() {
        guard index != poses.count - 1 else {
            return
        }
        
        index += 1
        changingPosition = true
    }
    
    func startWorkout() {
        index = -1
        
        startButton.isHidden = true
        timerView.isHidden = false
        poseLabel.isHidden = false
        
        startTimer()
    }
    
    func startTimer() {
        isPaused = false
    }
    
    func pauseTimer() {
        isPaused = true
    }
    
    func restart() {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //present(storyboard.instantiateViewController(withIdentifier: "vc") as! ViewController, animated: true, completion: nil)
        time = ViewController.changeTime
        changingPosition = true
        isPaused = false
        startButton.isHidden = false
    }
    
    func updateTimer() {
        guard !isPaused else {
            print("timer is paused")
            return
        }
        
        if ViewController.randomize {
            shufflePoses()
        } else {
            if shuffled {
                resetPoses()
            }
        }
        
        arcLayer.changeTime = ViewController.changeTime
        arcLayer.holdTime = ViewController.holdTime
        
        time -= 1
        arcLayer.animateArc()
        
        guard index + 1 < poses.count else {
            firstRound = false
            timerView.isHidden = true
            poseLabel.isHidden = true
            startButton.isHidden = false
            pauseTimer()
            startButton.setTitle("Restart", for: .normal)
            startButton.removeTarget(self, action: #selector(ViewController.startWorkout), for: .touchUpInside)
            startButton.addTarget(self, action: #selector(ViewController.restart), for: .touchUpInside)
            return
        }
        
        if time == 0 && !changingPosition {
            ding()
            
            time = ViewController.changeTime
            poseLabel.text = "Next up: \(poses[index+1])"
            
            arcLayer.changeSettings(.changingPosition)
            changingPosition = true
        }
        
        if time == 0 && changingPosition {
            time = ViewController.holdTime
            index += 1
            
            arcLayer.changeSettings(.holdingPosition)
            changingPosition = false
        }
    }
    
    func ding() {
        player.play()
    }
    
    func resetPoses() {
        poses = ["Tree L", "Tree R", "Triangle L", "Warrior 2 L", "Side-angle L", "Knee-down low lunge R", "Triangle R", "Warrior 2 R", "Side-angle R", "Knee-down low lunge L", "Tabletop", "Tabletop L leg, R arm", "Tabletop R leg, L arm", "Down dog", "Plank", "Low cobra", "Down dog", "Plank", "Up dog", "Locust", "Bow", "L Left over R twist", "R leg over L twist", "Reverse Plank", "Bridge", "Corpse"]
    }
    
    func shufflePoses() {
        let newPoses = NSMutableArray(capacity: poses.count)
        while poses.count > 0 {
            let randIndex = Int(arc4random_uniform(UInt32(poses.count)))
            let randPose = poses[randIndex]
            newPoses.add(randPose)
            poses.remove(at: randIndex)
        }
        poses = Array<String>(repeating: "", count: newPoses.count)
        
        var i = 0
        for pose in newPoses {
            poses[i] = pose as! String
            i += 1
        }
        
        shuffled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        pauseTimer()
        if let identifier = segue.identifier {
            if identifier == "settings" {
                let svc = segue.destination as! SettingsViewController
                svc.changeTime = ViewController.changeTime
                svc.holdTime = ViewController.holdTime
                svc.random = ViewController.randomize
            }
        }
    }

}

