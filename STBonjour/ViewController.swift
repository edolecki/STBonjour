//
//  ViewController.swift
//  STBonjour
//
//  Created by Eric Dolecki on 6/15/16.
//  Copyright © 2016 Eric Dolecki. All rights reserved.
//

import UIKit

struct Speaker
{
    var IPAddress: String   = "Unknown"
    var Name: String        = "Unknown"
    var MACAddress: String  = "Unknown"
    var DeviceType: String  = "Unknown"
    
    init(ip: String, name: String, mac: String, deviceType: String){
        self.IPAddress = ip
        self.Name = name
        self.MACAddress = mac
        self.DeviceType = deviceType
    }
}

class ViewController: UIViewController, NSNetServiceDelegate, UITableViewDelegate, UITableViewDataSource
{
    var nsns: NSNetService?
    var nsnsdel: BMNSDelegate?
    var nsb: NSNetServiceBrowser?
    var nsbdel: BMBrowserDelegate?
    var tableView: UITableView!
    var speakerArray = [String]()
    var speakerIPAddresses = [String]()
    var header: UILabel!
    var speakerObjectArray = [Speaker]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        header = UILabel(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 20))
        header.textAlignment = .Center
        header.textColor = UIColor.orangeColor()
        header.text = "SoundTouch Units"
        header.font = UIFont(name: "AvenirNext-Regular", size: 22.0)
        self.view.addSubview(header)
            
        tableView = UITableView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100))
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.darkGrayColor()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        let BM_DOMAIN = "local."
        let BM_TYPE = "_soundtouch._tcp."
        let BM_NAME = "hello"
        let BM_PORT : CInt = 1900
        
        /// Netservice.
        
        nsns = NSNetService(domain: BM_DOMAIN, type: BM_TYPE, name: BM_NAME, port: BM_PORT)
        nsnsdel = BMNSDelegate() //see bellow
        nsns?.delegate = nsnsdel
        nsns?.publish()
        
        /// Net service browser.
        
        nsb = NSNetServiceBrowser()
        nsbdel = BMBrowserDelegate() //see bellow
        nsb?.delegate = nsbdel
        
        EDProgressView.shared.showProgressView(view)
        
        nsb?.searchForServicesOfType(BM_TYPE, inDomain: BM_DOMAIN)
    }

    // Hide the status bar.
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speakerObjectArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        cell.textLabel!.text = speakerObjectArray[indexPath.row].Name //speakerArray[indexPath.row]
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        cell.backgroundColor = UIColor.clearColor()
        
        // Make sure the IP Address has been found and appended to the array first. Can be out of index.
        
        if indexPath.row < speakerIPAddresses.count {
            cell.detailTextLabel!.text = "IP: \(speakerObjectArray[indexPath.row].IPAddress), MAC: \(speakerObjectArray[indexPath.row].MACAddress)"
            cell.detailTextLabel!.textColor = UIColor.lightGrayColor()
        }
        
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        img.contentMode = .ScaleAspectFit
        
        // Associate device images with product.
        
        let speakerName = speakerObjectArray[indexPath.row].DeviceType
        if speakerName == "Lifestyle" {
            img.image = UIImage(named: "lifestyle.png")
        } else if speakerName == "SoundTouch 30" {
            img.image = UIImage(named: "soundtouch_30.png")
        } else if speakerName == "SoundTouch 20" {
            img.image = UIImage(named: "soundtouch_20.png")
        } else if speakerName == "SoundTouch Portable"{
            img.image = UIImage(named: "soundtouch_20.png")
        } else if speakerName == "SoundTouch 10" {
            img.image = UIImage(named: "soundtouch_10.png")
        } else if speakerName == "Wave SoundTouch" {
            img.image = UIImage(named: "wave_soundtouch.png")
        } else if speakerName == "SoundTouch SA-5" {
            img.image = UIImage(named: "sa5.png")
        } else if speakerName == "SoundTouch SA-4"{
            img.image = UIImage(named: "sa5.png")
        }
        
        cell.imageView?.image = img.image
        
        /*
         Device identifier strings
         ========================
         Lifestyle
         SoundTouch 10
         SoundTouch 20
         SoundTouch 30
         Wave SoundTouch
         SoundTouch SA-5
        */
        
        return cell
    }
}








class BMNSDelegate : NSObject, NSNetServiceDelegate
{    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func netServiceWillPublish(sender: NSNetService) {
        print("netServiceWillPublish:\(sender)");
    }
    
    func netServiceDidPublish(sender: NSNetService) {
        print("netServiceDidPublish:\(sender)")
        
        //We are done discovering. Let's show the user what we've found.
        
        let window = UIApplication.sharedApplication().keyWindow
        let vc = window?.rootViewController as! ViewController
        for i in 0..<vc.speakerIPAddresses.count {
            self.fetchSpeakerMacAddress( vc.speakerIPAddresses[i] )
        }
        
        // Let things settle before we try to display in the tableview.
        
        delay(6.0){
            EDProgressView.shared.hideProgressView()
            vc.header.text = "\(vc.speakerObjectArray.count) SoundTouch Units Discovered"
            vc.tableView.reloadData()
        }
    }
    
    func fetchSpeakerMacAddress( ip:String )
    {
        let url = NSURL(string: "http://" + ip + ":8090/info")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
            
            /*
             https://github.com/drmohundro/SWXMLHash
             This can parse XML pretty easily. Since we get that as return, bingo!
             */
            
            let xmlString = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            let xml = SWXMLHash.parse(xmlString)
            
            let mac = xml["info"].element?.attributes["deviceID"] // Need to add colon every 2
            //let finalMacAddress = mac?.pairs.joinWithSeparator(":") // Not needed for API.
            let type = xml["info"]["type"].element?.text
            let name = xml["info"]["name"].element?.text
            
            //print("Speaker Info: \(name!): \(type!),   MAC: \(finalMacAddress!), IP: \(ip)")
            
            let thisSpeaker = Speaker(ip: "\(ip)", name: name!, mac: mac!, deviceType: type!)
            //print(thisSpeaker)
            
            let window = UIApplication.sharedApplication().keyWindow
            let vc = window?.rootViewController as! ViewController
            vc.speakerObjectArray.append(thisSpeaker)
        }
        task.resume()
    }
      
    func netServiceWillResolve(sender: NSNetService) {
        print("** netServiceWillResolve:\(sender)")
    }
    
    func netService(sender: NSNetService, didNotResolve errorDict: [String : NSNumber]) {
        print("** netServiceDidNotResolve:\(sender)");
    }
    
    func netServiceDidResolveAddress(sender: NSNetService) {
        print("** netServiceDidResolve:\(sender)")
    }
    
    func netService(sender: NSNetService, didUpdateTXTRecordData data: NSData) {
        print("netServiceDidUpdateTXTRecordData:\(sender)");
    }
    
    func netServiceDidStop(sender: NSNetService) {
        print("netServiceDidStopService:\(sender)")
    }
    
    func netService(sender: NSNetService,
                    didAcceptConnectionWithInputStream inputStream: NSInputStream,
                                                       outputStream stream: NSOutputStream) {
        print("netServiceDidAcceptConnection:\(sender)");
    }
}

class BMBrowserDelegate : NSObject, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
    
    var services = [NSNetService]()
    
    func netServiceDidResolveAddress(sender: NSNetService)
    {
        let window = UIApplication.sharedApplication().keyWindow
        let vc = window?.rootViewController as! ViewController
        
        // Convert the data to IP Address.
        
        let theAddress = sender.addresses!.first! as NSData
        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
        if getnameinfo(UnsafePointer(theAddress.bytes), socklen_t(theAddress.length),
                       &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
            if let numAddress = String.fromCString(hostname) {
                //print("CONVERT IP: \(numAddress)")
                vc.speakerIPAddresses.append(numAddress)
                vc.speakerArray.append(sender.name)
            }
        }
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser,
                           didFindDomain domainName: String,
                                         moreComing moreDomainsComing: Bool) {
        print("netServiceDidFindDomain")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser,
                           didRemoveDomain domainName: String,
                                           moreComing moreDomainsComing: Bool) {
        print("netServiceDidRemoveDomain")
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser,
                           didFindService netService: NSNetService,
                                          moreComing moreServicesComing: Bool) {
        
        if netService.name != "hello" {
            services.append(netService) //retained so resolveWithTimeout will work (netServiceDidResolveAddress)
            netService.delegate = self
            netService.resolveWithTimeout(5.0)
        }
        
        if moreServicesComing == false {
            // Fires 2x. Why? Can't use as event.
        }
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser,
                           didRemoveService netService: NSNetService,
                                            moreComing moreServicesComing: Bool) {
        print("netServiceDidRemoveService")
    }
    
    func netServiceBrowserWillSearch(aNetServiceBrowser: NSNetServiceBrowser){
        print("netServiceBrowserWillSearch")
    }
    
    func netServiceBrowserDidStopSearch(netServiceBrowser: NSNetServiceBrowser) {
        print("netServiceDidStopSearch")
    }
    
}