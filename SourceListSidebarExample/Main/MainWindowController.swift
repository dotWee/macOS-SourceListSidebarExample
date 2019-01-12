//
//  MainWindowController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa
import AppKit

class MainWindowController: NSWindowController {
    
    let accountManager = AccountsManager.init()
    
    var mainSplitViewController: MainSplitViewController? = nil
    var mainSidebarViewController: MainSidebarViewController? = nil
    var mainContentViewController: MainContentViewController? = nil
    
    var selectedAccount: Variable<Account?> = Variable(nil)
    
    @IBAction func onToolbarAddAction(_ sender: NSToolbarItem) {
        self.onAddAccount()
    }
    
    @IBAction func onToolbarRefreshAction(_ sender: NSToolbarItem) {
        self.onRefreshAccounts()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func onAddAccount() {
        if mainSplitViewController != nil {
            mainSplitViewController?.onShowNewAccountSheet()
        } else {
            print("MainWindowController: Error mainViewController is nil")
        }
    }
    
    func onRefreshAccounts() {
        print("MainWindowController: onRefreshAccounts")
        if mainSidebarViewController != nil {
            mainContentViewController?.clearAccountView()
            mainSidebarViewController?.onAccountsChange()
        } else {
            print("MainWindowController: onRefreshAccounts mainSidebarViewController is nil!")
        }
    }

    func dialogOkCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
}
