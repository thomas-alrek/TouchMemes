import Cocoa
import AppKit

class TouchBarController: NSObject, NSTouchBarDelegate {
    
    static var shared = TouchBarController()
    
    var isPresented = false
    var touchBar : NSTouchBar?
    
    private override init() {
        super.init()
        self.touchBar = NSTouchBar()
        self.touchBar?.delegate = self
        self.touchBar?.defaultItemIdentifiers = [.textItem]
    }
    
    func refresh () {
        let wasPresented = isPresented
        dismissTouchBar()
        self.touchBar = nil
        self.touchBar = NSTouchBar()
        self.touchBar?.delegate = self
        self.touchBar?.defaultItemIdentifiers = [.textItem]
        if (wasPresented) {
            presentTouchBar()
        }
    }
    
    func setupControlStripPresence() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        let item = NSCustomTouchBarItem(identifier: .systemTrayItem)
        item.view = NSButton(image: NSImage(named: NSImage.Name(rawValue: "MenuBarIcon"))!, target: self, action: #selector(presentTouchBar))
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.systemTrayItem, true)
    }
    
    @objc private func presentTouchBar() {
        NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: .systemTrayItem)
        isPresented = true
    }
    
    private func dismissTouchBar() {
        NSTouchBar.minimizeSystemModalFunctionBar(touchBar)
        isPresented = false
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if (identifier == .textItem) {
            return TouchBarItem(identifier: .textItem)
        }
        return nil
    }
    
}

extension NSTouchBarItem.Identifier {
    static let textItem = NSTouchBarItem.Identifier("no.alrek.Shrug.textItem")
    static let systemTrayItem = NSTouchBarItem.Identifier("no.alrek.Shrug.systemTrayItem")
}
