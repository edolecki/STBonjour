//
//  PresetViewController.swift
//  STBonjour
//
//  Created by Eric Dolecki on 7/19/16.
//  Copyright © 2016 Eric Dolecki. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

/**
 This is really just to show some information about 
 the currently selected preset. The number and some 
 metadata that we have about it.
 
 THIS CONTROLLER IS NOT BEING IMPLEMENTED. SOON TO REMOVE.
 */

class PresetViewController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    var session: WCSession!
    var presetNumber = "1"
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let text = context as? String {
            presetNumber = text
            descriptionLabel.setText("Preset \(text)")
        }
        
        // Configure interface objects here.
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        
        if session.reachable {
            let dict = ["needPresetData":presetNumber] // 1 or 2 or ...
            session.sendMessage(dict, replyHandler: {(_: [String : AnyObject]) -> Void in
                    // handle reply from iPhone app here
                }, errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
    }

    // We received a response.
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        if let info = message as? Dictionary<String,String>{
            if let s = info["description"]{
                descriptionLabel.setText("Preset \(presetNumber)\n\(s)")
            }
        }
    }
    
    
    
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
