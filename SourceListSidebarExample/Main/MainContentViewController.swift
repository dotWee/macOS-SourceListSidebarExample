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
    
    @IBOutlet weak var textFieldHost: NSTextField!
    
    @IBOutlet weak var boxAccountSettings: NSBox!
    
    @IBOutlet weak var buttonDeleteAccount: NSButton!
    
    @IBAction func onButtonRemoveAccountAction(_ sender: NSButton) {
        if self.mainWindowController != nil {
            DataManager.sharedInstance.deleteAccount(account: account!)
            
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
        self.mainWindowController = self.view.window?.windowController as? MainWindowController
        self.mainWindowController!.mainContentViewController = self
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        if self.mainWindowController != nil {
            self.mainWindowController!.selectedAccount.asObservable().subscribe(onNext: { (account) in
                print("MainContentViewController: onNext account=\(String(describing: account))")
                
                self.account = account
                if account != nil {
                    self.fillAccountView(account: account!)
                } else {
                    self.clearAccountView()
                }
            }).disposed(by: appDelegate.mainDisposeBag)
            
            
        } else {
            print("MainContentViewController: Error, can't bind selectedAccount")
        }
        
        // Clear account view when data is changed
        DataManager.sharedInstance.accounts.asObservable().subscribe(onNext: { (accounts) in
            self.clearAccountView()
        }).disposed(by: appDelegate.mainDisposeBag)
    }
    
    func clearAccountView() {
        textFieldUsername.stringValue = ""
        textFieldHost.stringValue = ""
        
        imageView.isHidden = true
        boxAccountSettings.isHidden = true
        buttonDeleteAccount.isHidden = true
    }
    
    func fillAccountView(account: Account) {
        textFieldUsername.stringValue = account.username!
        
        if let hostOfAccount = DataManager.sharedInstance.getAllHosts()?.first(where: { (host) -> Bool in
            return host.hostId == account.hostId
        }) {
            textFieldHost.stringValue = "\(hostOfAccount.name!) (\(hostOfAccount.url!))"
        }
        
        imageView.isHidden = false
        boxAccountSettings.isHidden = false
        buttonDeleteAccount.isHidden = false
    }
}
