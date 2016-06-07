//
//  CountdownView.swift
//  CountDown
//
//  Created by Duong Nguyen on 06/06/2016.
//  Copyright © 2016 Oliu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SVProgressHUD

class CountdownView: UIViewController {
    let rootRef = FIRDatabase.database().reference().child("Timer")
    var setTime = ""
    var dueTime = ""
    var timeLeft = 0
    
    // NSTimer variable
    var countdownTimer = NSTimer()
    @IBOutlet var countdownLabel: UILabel!
    
    override func viewDidLoad() {
        // set progress style and show the progress icon
        SVProgressHUD.setDefaultMaskType(.Black)
        SVProgressHUD.show()
        
        // dispatch it in another queue so that it does not block main queue
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            self.rootRef.observeEventType(.Value, withBlock: { (snap: FIRDataSnapshot) in
                // grab start and end dates from database
                self.setTime = (snap.childSnapshotForPath("CurrentTime").value as? String)!
                self.dueTime = (snap.childSnapshotForPath("DueTime").value as? String)!
                
                // convert those dates to NSDate
                let setTimeInNSDate = self.dateFormmater(self.setTime)
                let dueTimeInNSDate = self.dateFormmater(self.dueTime)
                
                // calculate total time, time elapsed and the time left
                let totalTime = Int(dueTimeInNSDate.timeIntervalSinceDate(setTimeInNSDate))
                let timeElapse = Int(NSDate().timeIntervalSinceDate(setTimeInNSDate))
                self.timeLeft = totalTime - timeElapse
                
                // Only change the label if set date is after current date, and if time left is more than zero
                if self.timeLeft > 0 && NSDate().timeIntervalSinceDate(setTimeInNSDate) > 0 {
                    self.countdownLabel.text = self.timeFormatted(self.timeLeft)
                } else {
                    self.countdownLabel.text = self.timeFormatted(0)
                }
                
                // only start countdown if set date is after current date
                if NSDate().timeIntervalSinceDate(setTimeInNSDate) > 0 {
                    self.start()
                }
            })
        }
    }
    
    // convert string date to NSDate
    func dateFormmater(date: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.dateFromString(date)
        return date!
    }
    
    // start scheduled timer
    func start(){
        // disable progress
        SVProgressHUD.dismiss()
        self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CountdownView.onTick), userInfo: nil, repeats: true);
    }
    
    // every time it ticks update the label and reduce the amount of time left
    func onTick() {
        timeLeft -= 1
        if timeLeft < 0 {
            self.countdownTimer.invalidate()
        }
        if timeLeft > 0 {
            countdownLabel.text = timeFormatted(timeLeft)
        }
    }
    
    // convert the total number of seconds left into proper format
    private func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
