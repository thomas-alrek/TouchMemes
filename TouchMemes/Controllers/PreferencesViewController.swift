//
//  PreferencesViewController.swift
//  TouchMemes
//
//  Created by Thomas Alrek on 25/02/2018.
//  Copyright © 2018 Thomas Alrek. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    let selectedIndex = -1
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var segmentController: NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.headerView = nil
        tableView.reloadData()
    }
    
    override func keyDown(with event: NSEvent) {
        if event.type == .keyDown && event.keyCode == 0x33 {
            deleteRow()
        }
    }
    
    @IBAction func segmentControllerClick (_ sender: NSSegmentedCell) {
        switch sender.selectedSegment {
            case 0:
                addRow(sender: sender)
            case 1:
                deleteRow()
            case 2:
                if tableView.selectedRow >= 0 {
                    moveRowUp(tableView.selectedRow)
                }
                break
            case 3:
                if tableView.selectedRow >= 0 {
                    moveRowDown(tableView.selectedRow)
                }
                break
            default:
                break
        }
    }
    
    @IBAction func deleteRow (sender: AnyObject) {
        deleteRow()
    }
    
    func deleteRow () {
        if tableView.selectedRow >= 0 {
            AppDelegate.userPrefs?.remove(at: tableView.selectedRow)
            self.tableView.reloadData()
            AppDelegate.saveUserPrefs()
        }
    }
    
    func moveRowUp (_ index : Int) {
        if (index - 1 >= 0) {
            AppDelegate.userPrefs?.swapAt(index - 1, index)
            self.tableView.reloadData()
            AppDelegate.saveUserPrefs()
            tableView.selectRowIndexes(IndexSet(integer: index - 1), byExtendingSelection: false)
        }
    }

    func moveRowDown (_ index : Int) {
        if let count = AppDelegate.userPrefs?.count {
            if (index + 1 < count) {
                AppDelegate.userPrefs?.swapAt(index, index + 1)
                self.tableView.reloadData()
                AppDelegate.saveUserPrefs()
                tableView.selectRowIndexes(IndexSet(integer: index + 1), byExtendingSelection: false)
            }
        }
    }
    
    @IBAction func addRow (sender: AnyObject) {
        let prompt = NSAlert()
        let input = SheetTextField.init(frame: NSMakeRect(0,0,300,28))
        let inputView = NSScrollView.init(frame: NSMakeRect(0,0,300,28))
        inputView.hasVerticalScroller = true
        inputView.autohidesScrollers = true
        input.drawsBackground = true
        input.isEditable = true
        inputView.documentView = input
        prompt.addButton(withTitle: NSLocalizedString("Add", comment: ""))      // 1st button
        prompt.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))  // 2nd button
        prompt.messageText = NSLocalizedString("Add new text", comment: "")
        prompt.alertStyle = .informational
        prompt.accessoryView = inputView
        prompt.beginSheetModal(for: self.view.window!) { (response: NSApplication.ModalResponse) -> Void in
            if (input.stringValue.count > 0) {
                AppDelegate.userPrefs?.append(input.stringValue)
                self.tableView.reloadData()
                AppDelegate.saveUserPrefs()
            }
        }
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(send)
    }
    
}

extension PreferencesViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return AppDelegate.userPrefs?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return AppDelegate.userPrefs?[row] ?? nil
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        if let value = object as? String {
            if value.count > 0 {
                AppDelegate.userPrefs?[row] = object as! String
                AppDelegate.saveUserPrefs()
            }
        }
        tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let count = AppDelegate.userPrefs?.count ?? 0
        segmentController.setEnabled(count > 0 && tableView.selectedRow >= 0, forSegment: 1)
        segmentController.setEnabled(count > 0 && tableView.selectedRow > 0, forSegment: 2)
        segmentController.setEnabled(count > 0 && tableView.selectedRow >= 0 && tableView.selectedRow < count - 1, forSegment: 3)
    }
}

extension PreferencesViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> PreferencesViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "PreferencesViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PreferencesViewController else {
            fatalError("PreferencesViewController not found")
        }
        return viewcontroller
    }
}
