import Cocoa

@available(OSX 10.12.2, *)
class TouchBarItem: NSCustomTouchBarItem, NSScrubberDelegate, NSScrubberDataSource, NSScrubberFlowLayoutDelegate {
    
    private static let itemViewIdentifier = "TextItemViewIdentifier"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        
        let scrubber = NSScrubber()
        scrubber.scrubberLayout = NSScrubberFlowLayout()
        scrubber.register(
            NSScrubberTextItemView.self,
            forItemIdentifier: NSUserInterfaceItemIdentifier(TouchBarItem.itemViewIdentifier)
        )
        scrubber.mode = .free
        scrubber.selectionBackgroundStyle = .roundedBackground
        scrubber.delegate = self
        scrubber.dataSource = self
        view = scrubber
    }
    
    func write(withText text: String) {
        let source = CGEventSource(stateID: .hidSystemState)
        let eventKey = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true)
        let eventKeyUp = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false)
        var utf16array = Array(text.utf16)
        eventKey!.keyboardSetUnicodeString(stringLength: utf16array.count, unicodeString: &utf16array)
        eventKeyUp!.keyboardSetUnicodeString(stringLength: utf16array.count, unicodeString: &utf16array)
        eventKey!.post(tap: CGEventTapLocation.cghidEventTap)
        eventKeyUp!.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return AppDelegate.userPrefs?.count ?? 0
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        var returnItemView = NSScrubberItemView()
        if let textValue = AppDelegate.userPrefs?[index] {
            if let itemView =
                scrubber.makeItem(
                    withIdentifier: NSUserInterfaceItemIdentifier(rawValue: type(of: self).itemViewIdentifier),
                    owner: nil
                ) as? NSScrubberTextItemView {
                    itemView.textField.stringValue = textValue
                    returnItemView = itemView
                }
        }
        return returnItemView
    }
    
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        if let textValue = AppDelegate.userPrefs?[itemIndex] {
            var size = textValue.size(withAttributes: [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 30.0)])
            size.height = 30
            return size
        }
        return NSSize()
    }
    
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
        if let textValue = AppDelegate.userPrefs?[index] {
            write(withText: textValue)
            scrubber.selectedIndex = -1
        }
    }
}

