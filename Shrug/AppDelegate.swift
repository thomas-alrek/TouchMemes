import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBar = NSStatusBar.system
    var statusBarItem : NSStatusItem = NSStatusItem()
    var menu: NSMenu = NSMenu()
    var menuItem : NSMenuItem = NSMenuItem()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addMenubarIcon()
        TouchBarController.shared.setupControlStripPresence()
    }
    
    func addMenubarIcon () {
        statusBarItem = statusBar.statusItem(withLength: -1)
        statusBarItem.menu = menu
        statusBarItem.title = Constants.shrug
        menuItem.title = "Exit"
        menuItem.action = #selector(NSApplication.shared.terminate)
        menuItem.keyEquivalent = ""
        menu.addItem(menuItem)
    }
    
}

