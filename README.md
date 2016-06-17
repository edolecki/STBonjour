# STBonjour
Swift implementation of Bose SoundTouch device discovery using Bonjour. This project is meant as a kick start to your SoundTouch applications.

![Example](http://www.ericd.net/stDiscoveryImage.jpg "Example")

### Requirements
----
##### Hardware
In order to test this implementation, it's required that you have a Bose SoundTouch device 
set up and present on your Wi-Fi network. The iOS device on which you run this application
needs to be on the same Wi-Fi network as the Bose SoundTouch device or devices. 

##### Software
You should have a copy of Xcode 7.3 or greater. This project uses Swift 2+.

### Information
----
This project will attempt to search your network to discover Bose SoundTouch devices. Once discovered, the IP Address(s) will be resolved in order to use the public Bose SoundTouch APIs in order to gather up additional information about each device. 

This project is about discovery. You'll note that we only use a single "/info" HTTP GET in order to retrieve information from each discovered speaker. We also do not set up a websocket to anything. That functionality is for another project - or an addition to this one. 

If you need a copy of the Bose SoundTouch Developers API documentation, you can find those here: 
* [Bose Developers API ](http://products.bose.com/api-developer/index.html)

You will receive (after a request) the Discovery documentation, WebServices documentation, and LicenseAgreement. There is also a link to API Support at that page.

### Shout Out
----
Thanks to SWXMLHash.swift written by David Mohundro - which is used in this project to make XML parsing much easier. This is used when getting information back from each discovered device and parsing it down.

### ToDo Items
----
Feel free to tackle some of this on your own or in general to make improvements to this project. This was my very first foray into Bonjour discovery and there might be better ways of getting things done. 

1. Refresh mechanism to rescan the network.
2. Device removal UI updating.
3. A more robust discovery loop and UI delivery.
4. At times with the presence of a multitude of SoundTouch devices this application will find and gather data for almost all devices - sometimes all. It should always find all of them.
