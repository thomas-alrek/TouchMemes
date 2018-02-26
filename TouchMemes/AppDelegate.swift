//
//  AppDelegate.swift
//  TouchMemes
//
//  Created by Thomas Alrek on 25/02/2018.
//  Copyright © 2018 Thomas Alrek. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    
    static var userPrefs : [String]?
    
    var storyBoard : NSStoryboard?
    var preferencesWindowController : NSWindowController?
    
    let popover = NSPopover()
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.userPrefs = loadUserPrefs()
        createStatusbarMenu()
        TouchBarController.shared.setupControlStripPresence()
        storyBoard = NSStoryboard.init(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        preferencesWindowController = storyBoard?
            .instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier(
                    rawValue: "PreferencesWindow"
                )
            ) as? NSWindowController
    }

    func createStatusbarMenu () {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "MenuBarIcon"))
            button.action = #selector(togglePopover)
        }
        popover.contentViewController = PreferencesViewController.freshController()
        popover.appearance = NSAppearance(named: .aqua)
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
    
    func loadUserPrefs () -> [String] {
        let defaults = UserDefaults.standard
        if defaults.stringArray(forKey: "TextItems") == nil {
            defaults.set(Constants.defaultTextItems, forKey: "TextItems")
        }
        if let prefs = defaults.stringArray(forKey: "TextItems") {
            return prefs
        }
        return [String]()
    }
    
    static func saveUserPrefs () {
        let defaults = UserDefaults.standard
        defaults.set(AppDelegate.userPrefs!, forKey: "TextItems")
        TouchBarController.shared.refresh()
    }

}

