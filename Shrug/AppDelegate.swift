import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        TouchBarController.shared.setupControlStripPresence()
    }
    
}

