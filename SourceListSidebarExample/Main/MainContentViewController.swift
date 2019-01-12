//
//  MainContentViewController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa
import AppKit

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
            self.clearAccountView()
        }
    }
    
    var mainWindowController: MainWindowController? = nil
    var account: Account? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.clearAccountView()
    }
    
    override func viewDidAppear() {
        self.mainWindowController = self.view.window?.windowController as! MainWindowController
        self.mainWindowController!.mainContentViewController = self
        
        if self.mainWindowController != nil {
            self.mainWindowController!.selectedAccount.asObservable().subscribe(onNext: { (account) in
                print("MainContentViewController: onNext account=\(account)")
                
                self.account = account
                if account != nil {
                    self.fillAccountView(account: account!)
                } else {
                    self.clearAccountView()
                }
            })
        } else {
            print("MainContentViewController: Error, can't bind selectedAccount")
        }
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
}
