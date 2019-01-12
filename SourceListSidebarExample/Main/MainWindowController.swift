//
//  MainWindowController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    let accountManager = AccountsManager.init()
    
    var mainSplitViewController: MainSplitViewController? = nil
    var mainSidebarViewController: MainSidebarViewController? = nil
    var mainContentViewController: MainContentViewController? = nil
    
    @IBAction func onToolbarAddAction(_ sender: NSToolbarItem) {
        if mainSplitViewController != nil {
            mainSplitViewController?.onShowNewAccountSheet()
        } else {
            print("MainWindowController: Error mainViewController is nil")
        }
    }
    
    @IBAction func onToolbarRefreshAction(_ sender: NSToolbarItem) {
        if mainSidebarViewController != nil {
            mainSidebarViewController?.onAccountsChange()
        } else {
            print("MainWindowController: onToolbarRefreshAction Error mainSidebarViewController is nil")
        }
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func onAccountSelected(account: Account) {
        print("MainWindowController: onAccountSelected account=\(account)")
        if mainContentViewController != nil {
            mainContentViewController?.setAccount(account: account)
        } else {
            print("MainWindowController: onAccountSelected mainContentViewController is nil!")
        }
    }
    
    func onRefreshAccounts() {
        print("MainWindowController: onRefreshAccounts")
        if mainSidebarViewController != nil {
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
