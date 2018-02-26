import AppKit

class SheetTextField : NSTextField {
    
    var isFirstResponder = false
    
    override func viewWillDraw() {
        if (!isFirstResponder) {
            DispatchQueue.main.async() {
                self.window?.makeFirstResponder(self)
                self.isFirstResponder = true
            }
        }
    }
}
