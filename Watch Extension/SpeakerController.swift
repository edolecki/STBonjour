//
//  SpeakerController.swift
//  STBonjour
//
//  Created by Eric Dolecki on 7/12/16.
//  Copyright © 2016 Eric Dolecki. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class SpeakerController: WKInterfaceController, WCSessionDelegate {

    var session:WCSession!
    var speakerName = "Unknown"
    
    @IBOutlet var speakerLabel: WKInterfaceLabel!
    @IBOutlet var volumeSlider: WKInterfaceSlider!
    @IBOutlet var buttonOne:    WKInterfaceButton!
    @IBOutlet var buttonTwo:    WKInterfaceButton!
    @IBOutlet var buttonThree:  WKInterfaceButton!
    @IBOutlet var buttonFour:   WKInterfaceButton!
    @IBOutlet var buttonFive:   WKInterfaceButton!
    @IBOutlet var buttonSix:    WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        if let text = context as? String {
            speakerLabel.setText(text)
            speakerName = text
        }
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            print("session for SpeakerController is active.")
        }
        
        if session.reachable
        {
            // 1. We need to fetch the current volume level for the slider control. Default is 50 for the control.
            
            let dict = ["request":"vol"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                    // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            
            // 2. Is there a selected speaker and is it playing a preset already? If so, which preset is active? Show it.
            
            let newDict = ["requestCurrentPreset":"requestCurrentPreset"]
            session.sendMessage(newDict, replyHandler: {(_: [String : AnyObject]) -> Void in
                    // handle reply from iPhone app here
                print("error requestCurrentPreset")
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
    }
    
    // iOS sent us the value of the current speaker.
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject])
    {
        if let info = message as? Dictionary<String,String>{
            if let s = info["volumeValue"]{
                let fVolume = Float(s)
                volumeSlider.setValue(fVolume!)
            }
            
            if let s = info["description"]
            {
                let action = WKAlertAction(title: "OK", style: WKAlertActionStyle.Default, handler: { () -> Void in
                    //
                })                
                let arr = s.characters.split("_", maxSplit: Int.max, allowEmptySlices: false).map(String.init)
                self.presentAlertControllerWithTitle("Preset \(arr[0])", message: "\n\(arr[1])", preferredStyle: WKAlertControllerStyle.Alert, actions: [action])
            }
            
            // Information from iOS App ViewController when we launched.
            
            if let s = info["presetIndex"]
            {
                let indx = Int(s)
                clearAllButtons()
                
                if indx == 1 {
                    let attString = NSMutableAttributedString(string: "1")
                    attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
                    buttonOne.setBackgroundColor(UIColor.greenColor())
                    buttonOne.setAttributedTitle(attString)
                    
                } else if indx == 2 {
                    let attString = NSMutableAttributedString(string: "2")
                    attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
                    buttonTwo.setBackgroundColor(UIColor.greenColor())
                    buttonTwo.setAttributedTitle(attString)
                    
                } else if indx == 3 {
                    let attString = NSMutableAttributedString(string: "3")
                    attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
                    buttonThree.setBackgroundColor(UIColor.greenColor())
                    buttonThree.setAttributedTitle(attString)
                    
                } else if indx == 4 {
                    let attString = NSMutableAttributedString(string: "4")
                    attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
                    buttonFour.setBackgroundColor(UIColor.greenColor())
                    buttonFour.setAttributedTitle(attString)
                    
                } else if indx == 5 {
                    let attString = NSMutableAttributedString(string: "5")
                    attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
                    buttonFive.setBackgroundColor(UIColor.greenColor())
                    buttonFive.setAttributedTitle(attString)
                    
                } else if indx == 6 {
                    let attString = NSMutableAttributedString(string: "6")
                    attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
                    buttonSix.setBackgroundColor(UIColor.greenColor())
                    buttonSix.setAttributedTitle(attString)
                    
                }
            }
        }
    }
    
    // self.popController()
    
    func clearAllButtons()
    {
        var attString = NSMutableAttributedString(string: "1")
        attString.setAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], range: NSMakeRange(0, attString.length))
        buttonOne.setAttributedTitle(attString)
        buttonOne.setBackgroundColor(nil)
        
        attString = NSMutableAttributedString(string: "2")
        attString.setAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], range: NSMakeRange(0, attString.length))
        buttonTwo.setAttributedTitle(attString)
        buttonTwo.setBackgroundColor(nil)
        
        attString = NSMutableAttributedString(string: "3")
        attString.setAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], range: NSMakeRange(0, attString.length))
        buttonThree.setAttributedTitle(attString)
        buttonThree.setBackgroundColor(nil)
        
        attString = NSMutableAttributedString(string: "4")
        attString.setAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], range: NSMakeRange(0, attString.length))
        buttonFour.setAttributedTitle(attString)
        buttonFour.setBackgroundColor(nil)
        
        attString = NSMutableAttributedString(string: "5")
        attString.setAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], range: NSMakeRange(0, attString.length))
        buttonFive.setAttributedTitle(attString)
        buttonFive.setBackgroundColor(nil)
        
        attString = NSMutableAttributedString(string: "6")
        attString.setAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], range: NSMakeRange(0, attString.length))
        buttonSix.setAttributedTitle(attString)
        buttonSix.setBackgroundColor(nil)
    }
    
    
    
    @IBAction func presetOnePressed() {
        if session.reachable
        {
            WKInterfaceDevice.currentDevice().playHaptic(.Click)
            let dict = ["preset":"1"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            
            // Button UI update.
            
            clearAllButtons()
            let attString = NSMutableAttributedString(string: "1")
            attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
            buttonOne.setBackgroundColor(UIColor.greenColor())
            buttonOne.setAttributedTitle(attString)
            
            let dict2 = ["needPresetData":"1"]
            session.sendMessage(dict2, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            
            //pushControllerWithName("SinglePreset", context: "1")
            
        }
    }
    
    @IBAction func presetTwoPressed()
    {
        if session.reachable
        {
            WKInterfaceDevice.currentDevice().playHaptic(.Click)
            let dict = ["preset":"2"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                    // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            
            clearAllButtons()
            let attString = NSMutableAttributedString(string: "2")
            attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
            buttonTwo.setBackgroundColor(UIColor.greenColor())
            buttonTwo.setAttributedTitle(attString)
            
            let dict2 = ["needPresetData":"2"]
            session.sendMessage(dict2, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            //pushControllerWithName("SinglePreset", context: "2")
        }
    }
    
    @IBAction func presetThreePressed() {
        if session.reachable
        {
            WKInterfaceDevice.currentDevice().playHaptic(.Click)
            let dict = ["preset":"3"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            
            clearAllButtons()
            let attString = NSMutableAttributedString(string: "3")
            attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
            buttonThree.setBackgroundColor(UIColor.greenColor())
            buttonThree.setAttributedTitle(attString)
            
            let dict2 = ["needPresetData":"3"]
            session.sendMessage(dict2, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            //pushControllerWithName("SinglePreset", context: "3")
        }
    }
    
    @IBAction func presetFourPressed() {
        if session.reachable
        {
            WKInterfaceDevice.currentDevice().playHaptic(.Click)
            let dict = ["preset":"4"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            
            clearAllButtons()
            let attString = NSMutableAttributedString(string: "4")
            attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
            buttonFour.setBackgroundColor(UIColor.greenColor())
            buttonFour.setAttributedTitle(attString)
            
            let dict2 = ["needPresetData":"4"]
            session.sendMessage(dict2, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            //pushControllerWithName("SinglePreset", context: "4")
        }
    }
    
    @IBAction func presetFivePressed() {
        if session.reachable
        {
            WKInterfaceDevice.currentDevice().playHaptic(.Click)
            let dict = ["preset":"5"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            
            clearAllButtons()
            let attString = NSMutableAttributedString(string: "5")
            attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
            buttonFive.setBackgroundColor(UIColor.greenColor())
            buttonFive.setAttributedTitle(attString)
            
            let dict2 = ["needPresetData":"5"]
            session.sendMessage(dict2, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            //pushControllerWithName("SinglePreset", context: "5")
        }
    }
    
    @IBAction func presetSixPressed() {
        if session.reachable
        {
            WKInterfaceDevice.currentDevice().playHaptic(.Click)
            let dict = ["preset":"6"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            
            clearAllButtons()
            let attString = NSMutableAttributedString(string: "6")
            attString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, attString.length))
            buttonSix.setBackgroundColor(UIColor.greenColor())
            buttonSix.setAttributedTitle(attString)
            
            let dict2 = ["needPresetData":"6"]
            session.sendMessage(dict2, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
            //pushControllerWithName("SinglePreset", context: "6")
        }
    }
    
    @IBAction func volumeSliderChanged(value: Float) {
        let roundedValue = Int(round(value))
        print("vol: \(roundedValue)")
        
        // Send this to iOS to adjust volume?
        
        if session.reachable
        {
            let val = "\(roundedValue)__\(speakerName)"
            let dict = ["volume":val]
            
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
