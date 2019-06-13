//
//  TimerViewController.swift
//  finalProject
//
//  Created by Apple on 6/13/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    
    var seconds = 301
    var timer = Timer()
    var isTimerRunning = false
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    
    
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate "time's up!"
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    
    @IBAction func startBtn(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
        }
    }
    
    var resumeTapped = false
    
    
    
    @IBAction func pauseBtn(_ sender: UIButton) {
        let pauseText = (sender as AnyObject)
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            pauseText.setTitle("Resume", for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            pauseText.setTitle("Pause", for: .normal)
        }
    }
    
    
    @IBAction func resetBtn(_ sender: UIButton) {
        timer.invalidate()
        seconds = 300
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
}
