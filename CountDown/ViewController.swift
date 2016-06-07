//
//  ViewController.swift
//  CountDown
//
//  Created by Duong Nguyen on 06/06/2016.
//  Copyright © 2016 Oliu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import RMDateSelectionViewController

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var starLabel: UILabel!
    
    @IBOutlet var endLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
        let date = dateFormatterToString(NSDate())
        starLabel.text = String(date)
        endLabel.text = String(date)
    }
    
    // convert NSDate to String
    func dateFormatterToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.stringFromDate(date)
        return date
    }
    
    // convert string date to NSDate
    func dateFormatterToNSDate(date: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.dateFromString(date)
        return date!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showTimer(sender: UIButton) {
        // reference of the paths
        let rootRef = FIRDatabase.database().reference().child("Timer")
        let currentTimeRef = rootRef.child("CurrentTime")
        let endDateRef = rootRef.child("DueTime")
        
        // convert end dates and start dates to NSDate
        let startDateInNSDate = dateFormatterToNSDate(starLabel.text!)
        let endDateInNSDate = dateFormatterToNSDate(endLabel.text!)
        
        // only change the value in the database if the end date is after the start date
        if endDateInNSDate.timeIntervalSinceDate(startDateInNSDate) <= 0 {
            print("Please add an edit date after the start date")
        } else {
            currentTimeRef.setValue(starLabel.text)
            endDateRef.setValue(endLabel.text)
        }
    }

    // Date Picker UI
    @IBAction func openDate(sender: UIButton) {
        // create select action
        let selectAction: RMAction = RMAction(title: "Select", style: RMActionStyle.Done , andHandler: {(controller: RMActionController) -> Void in
            self.endLabel.text = self.dateFormatterToString((controller.contentView as! UIDatePicker).date)
        })!
        
        //Create cancel action
        let cancelAction: RMAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel, andHandler: {(controller: RMActionController) -> Void in
        })!
        
        // create the now button
        let nowAction: RMAction = RMAction(title: "Now", style: RMActionStyle.Additional, andHandler: {(controller: RMActionController) -> Void in
            ((controller.contentView as! UIDatePicker)).date = NSDate()
        })!
        nowAction.dismissesActionController = false
        
        // create the 1 hour button
        let in1Hour: RMAction = RMAction(title: "1 Hour", style: RMActionStyle.Additional, andHandler: {(controller: RMActionController) -> Void in
            (controller.contentView as? UIDatePicker)!.date = NSDate(timeIntervalSinceNow: 60 * 60)
        })!
        in1Hour.dismissesActionController = false
        
        // create the 2 hour button
        let in2Hours: RMAction = RMAction(title: "2 Hours", style: RMActionStyle.Additional, andHandler: {(controller: RMActionController) -> Void in
            (controller.contentView as? UIDatePicker)!.date = NSDate(timeIntervalSinceNow: 120 * 60)
        })!
        in2Hours.dismissesActionController = false
        
        // group the hours button together
        let groupedAction: RMGroupedAction = RMGroupedAction(style: RMActionStyle.Additional, andActions: [in1Hour, in2Hours])!
        
        //Create date selection view controller
        let dateSelectionController: RMDateSelectionViewController = RMDateSelectionViewController(style: .White, selectAction: selectAction, andCancelAction: cancelAction)!
        // Add action buttons
        dateSelectionController.addAction(nowAction)
        dateSelectionController.addAction(groupedAction)
        // add Title
        dateSelectionController.title = "Test"
        dateSelectionController.message = "This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'."
        self.presentViewController(dateSelectionController, animated: true, completion: nil)
    }
    
    @IBAction func pickStartDate(sender: UIButton) {
        // create select action
        let selectAction: RMAction = RMAction(title: "Select", style: RMActionStyle.Done , andHandler: {(controller: RMActionController) -> Void in
            self.starLabel.text = self.dateFormatterToString((controller.contentView as! UIDatePicker).date)
        })!
        
        //Create cancel action
        let cancelAction: RMAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel, andHandler: {(controller: RMActionController) -> Void in
        })!
        
        // create the now button
        let nowAction: RMAction = RMAction(title: "Now", style: RMActionStyle.Additional, andHandler: {(controller: RMActionController) -> Void in
            ((controller.contentView as! UIDatePicker)).date = NSDate()
        })!
        nowAction.dismissesActionController = false
        
        //Create date selection view controller
        let dateSelectionController: RMDateSelectionViewController = RMDateSelectionViewController(style: .White, selectAction: selectAction, andCancelAction: cancelAction)!
        // Add action buttons
        dateSelectionController.addAction(nowAction)
        // add Title
        dateSelectionController.title = "Test"
        dateSelectionController.message = "This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'."
        self.presentViewController(dateSelectionController, animated: true, completion: nil)

    }
    
}
