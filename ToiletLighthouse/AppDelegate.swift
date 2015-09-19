//
//  AppDelegate.swift
//  ToiletLighthouse
//
//  Created by Memorysaver on 8/29/15.
//  Copyright (c) 2015 iCHEF. All rights reserved.
//

import Cocoa
import IOBluetooth
import IOBluetoothUI


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)

    let startMenu:NSMenuItem = NSMenuItem(title: "Start Server", action: Selector("startServer"), keyEquivalent: "")
    let stopMenu:NSMenuItem = NSMenuItem(title: "Stop Server", action: Selector("stopServer"), keyEquivalent: "")
    let quitMenu:NSMenuItem = NSMenuItem(title: "Quit", action: Selector("terminate:"), keyEquivalent: "q")
    var isLaunched = false
    
    var device:ToiletLightHouseDevice = ToiletLightHouseDevice()
    

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if let button = statusBarItem.button {
            button.image = NSImage(named: "lighthouse")
        }
        
        
        let menu = NSMenu()
        
        menu.addItem(startMenu)
        menu.addItem(stopMenu)
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(quitMenu)
        
        statusBarItem.menu = menu
        
        //啟動服務
        
        //必定會啟動client來尋找服務
        ToiletLightHouseClient.sharedInstance.startService()
        
        
    }
    
    func startServer() {
        
        self.startMenu.enabled = false
        self.startMenu.hidden = true
        self.stopMenu.enabled = true
        self.stopMenu.hidden = false
        
        ToiletLightHouseServer.sharedInstance.startService()
        
        
        //建立藍芽連線
        self.device.connect()
        
        //告知device server 已經啟動
        self.device.sentServerLaunchedSignal()
        
        //要求device回傳開關的狀態
        self.device.sentTest()
        
    }
    
    func stopServer() {
        
        self.startMenu.enabled = true
        self.startMenu.hidden = false
        self.stopMenu.enabled = false
        self.stopMenu.hidden = true
        
        //自動尋找bluetooth  device
        ToiletLightHouseServer.sharedInstance.stopService()
        //告知device server 已經關閉
        self.device.sentServerStoppedSignal()
        
        self.device.disconnect()
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

