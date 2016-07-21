//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Eric Dolecki on 7/12/16.
//  Copyright © 2016 Eric Dolecki. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

/*

 This is the entry ViewController for the Apple Watch extension.
 
*/
class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var picker: WKInterfacePicker!
    @IBOutlet var refreshButton: WKInterfaceButton!
    @IBOutlet var spinnerImage: WKInterfaceImage!
    @IBOutlet var selectButton: WKInterfaceButton!
    
    var session:WCSession!
    var speakerList = []
    var speakerController:SpeakerController!
    var thisList:[String] = []
    var currentIndex = 0
    
    @IBAction func pickerSelectedItemChange(value: Int) {
        currentIndex = value
    }
    
    @IBAction func selectSpeaker()
    {
        // Tell the second screen to use the speaker string value.
        
        if thisList.count == 0 {
            return
        }
        
        // Taptic Engine click.
        
        WKInterfaceDevice.currentDevice().playHaptic(.Success)
        
        // Play a tink sound. BT if paired with headphones, otherwise through watch speaker.
        // Forget this... watch asked what to Airplay to. Not what I wanted ;)
        
        /*
        let assetURL = NSBundle.mainBundle().URLForResource("button-24", withExtension: "wav")
        let asset = WKAudioFileAsset(URL: assetURL!)
        let playerItem = WKAudioFilePlayerItem(asset: asset)
        let audioFilePlayer = WKAudioFilePlayer(playerItem: playerItem)
        audioFilePlayer.play()
        */
        
        // We need to make sure the iOS application has the correct
        // speaker selected (so calls work appropriately).
        
        if session.reachable {
            let dict = ["selected":thisList[currentIndex]]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                    // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
        
        // Now navigate to the control view.
        
        pushControllerWithName("presetView", context: thisList[currentIndex])
    }
    
    // Ask the iOS app to refresh the list of speakers. What happens if app isn't running? WKInterfaceController.openParentApplication?
    
    @IBAction func refreshList()
    {
        if session.reachable
        {
            WKInterfaceDevice.currentDevice().playHaptic(.Start)
            refreshButton.setEnabled(false)
            
            let dict = ["refresh":"refresh"]
            spinnerImage.setHidden(false)
            picker.setHidden(true)
            selectButton.setHidden(true)
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                    // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
    }
    
    // Find devices button.
    
    @IBAction func test()
    {
        if session.reachable {
            print("reachable")
            let dict = ["status":"fetch"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                    // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
        /*
        let cancel = WKAlertAction(title: "Cancel", style: WKAlertActionStyle.Cancel, handler: { () -> Void in
            self.findDevicesButton.setHidden(false)
        })
        
        let action = WKAlertAction(title: "Action", style: WKAlertActionStyle.Default, handler: { () -> Void in
            self.findDevicesButton.setHidden(false)
        })
        
        self.presentAlertControllerWithTitle("Alert", message: "Example watchOS 2 alert interface", preferredStyle: WKAlertControllerStyle.SideBySideButtonsAlert, actions: [cancel, action])
        */
    }
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        picker.resignFocus()
        spinnerImage.setImageNamed("ai")
        spinnerImage.startAnimatingWithImagesInRange(NSRange(location: 0,length: 40), duration: 1.0, repeatCount: 0)
        spinnerImage.setHidden(true)
        picker.setHidden(true)
        selectButton.setHidden(true)
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            print("session active")
        }
        
        // Ask the iOS application if it has a speaker list it can send us already?
        
        if session.reachable {
            let dict = ["doYouHaveASpeakerList":"doYouHaveASpeakerList"]
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                    // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
    }
    
    //MARK: - Message from iOS Application -
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject])
    {
        print("Watch Extension got from iOS App: \(message)")
        
        if let info = message as? Dictionary<String,String> {
            if let s = info["status"] {
                print(s) // Should be "load"
                
            } else if let _ = info["speaker_0"] {
                
                thisList = []
                spinnerImage.setHidden(true)
                picker.setHidden(false)
                selectButton.setHidden(false)
                
                // We have a speaker or a couple speakers. We need to sort to match display in iOS.
                
                for (k,v) in Array(message).sort({$0.0 < $1.0}){
                    print("\(k):\(v)")
                    thisList.append(v as! String)
                }
                
                print(thisList)
                
                var pickerItems:[WKPickerItem] = []
                for name in thisList {
                    let pi = WKPickerItem()
                    pi.title = name
                    pi.caption = "SPEAKER"
                    pickerItems.append(pi)
                }
                
                WKInterfaceDevice.currentDevice().playHaptic(.Stop)
                refreshButton.setEnabled(true)
                
                picker.setItems(pickerItems)
                picker.setSelectedItemIndex(0)
                picker.focus()
                selectButton.setHidden(false)
                
                // We could have a list here.
                
                print("We receieved \(message.count) speakers to display.")
                
            } else {
                
                print("oops.")
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            // Anything needed on UI thread.
        }
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user.
        
        super.willActivate()

        // This fires every time the view comes into view. 
        
        // Do this again to make the Load button work for calls? Yes. This works.
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        // Let's test WatchOS 2 NSURLSession... hard-coded for now. Can we DO THIS on the watch?!?
        // This should display when launched if successful. Need 2.2.2 symbols in Xcode though.
        // Tested in simulators... I don't think we can POST - saw "test watch error"
        
        /*
        let thisSpeakerIP = "192.168.1.170" // ST Rivendell
        let url = NSURL(string:"http://\(thisSpeakerIP):8090/key")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let paramString = "<key state=\"press\" sender=\"Gabbo\">PRESET_4</key>"
        
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("test watch error")
                return
            }
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("dataString: '\(dataString!)'")
            
            let action = WKAlertAction(title: "OK", style: WKAlertActionStyle.Default, handler: { () -> Void in
                //
            })
            
            dispatch_async(dispatch_get_main_queue()) {
                self.presentAlertControllerWithTitle("NSURLSession", message: "Got \(dataString!)", preferredStyle: WKAlertControllerStyle.SideBySideButtonsAlert, actions: [action])
            }
        }
        task.resume()
        */
    }

    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible.
        
        super.didDeactivate()
    }

}
