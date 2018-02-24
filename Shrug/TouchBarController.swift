import Cocoa
import AppKit

class TouchBarController: NSObject, NSTouchBarDelegate {
    
    static let shared = TouchBarController()
    
    let pasteboard = NSPasteboard.general
    var debounce = -2
    
    let touchBar = NSTouchBar()
    
    private override init() {
        super.init()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.systemTrayItem]
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    }
    
    func setupControlStripPresence() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        let item = NSCustomTouchBarItem(identifier: .systemTrayItem)
        item.view = NSButton(image: #imageLiteral(resourceName: "TouchBar.Apps"), target: self, action: #selector(presentTouchBar))
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.systemTrayItem, true)
    }
    
    @objc private func presentTouchBar() {
        NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: .systemTrayItem)
    }
    
    private func dismissTouchBar() {
        NSTouchBar.minimizeSystemModalFunctionBar(touchBar)
    }
    
    func paste(withText text: String) {
        debounce = debounce > 5 ? 0 : debounce
        if (debounce == 0) {
            pasteboard.setString(text, forType: NSPasteboard.PasteboardType.string)
            DCPostCommandAndKey(KEY_CODE_V)
        }
        debounce += 1
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        dismissTouchBar()
        paste(withText: Constants.shrug)
        return nil
    }
    
}


