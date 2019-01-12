//
//  MainContentViewController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class MainContentViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    @IBOutlet weak var textFieldUsername: NSTextField!
    
    @IBOutlet weak var textFieldProvider: NSTextField!
    
    @IBOutlet weak var boxAccountSettings: NSBox!
    
    @IBOutlet weak var buttonDeleteAccount: NSButton!
    
    @IBAction func onButtonDeleteAccountAction(_ sender: NSButton) {
        if self.mainWindowController != nil {
            self.mainWindowController?.accountManager.deleteAccount(account: account!)
            self.mainWindowController?.onRefreshAccounts()
            self.setAccount(account: nil)
        }
    }
    
    var mainWindowController: MainWindowController? = nil
    var account: Account? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        setAccount(account: nil)
    }
    
    override func viewDidAppear() {
        self.mainWindowController = self.view.window?.windowController as! MainWindowController
        self.mainWindowController!.mainContentViewController = self
    }
    
    func clearAccountView() {
        imageView.image = nil
        textFieldUsername.stringValue = ""
        textFieldProvider.stringValue = ""
        buttonDeleteAccount.isEnabled = false
    }
    
    func fillAccountView(account: Account) {
        imageView.image = NSImage.init(imageLiteralResourceName: "NSUserAccounts")
        textFieldUsername.stringValue = account.username!
        textFieldProvider.stringValue = ProviderManager.asStringFromInt(provider: Int(account.provider))!
        buttonDeleteAccount.isEnabled = true
    }
    
    func setAccount(account: Account?) {
        print("MainContentViewController: setAccount=\(account)")
        
        if (account == nil) {
            self.clearAccountView()
            return
        }
        
        self.account = account!
        self.fillAccountView(account: account!)
    }
}
