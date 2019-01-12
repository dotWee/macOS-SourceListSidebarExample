//
//  AddAccountViewController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class AddAccountViewController: NSViewController {

    @IBOutlet weak var textFieldUsername: NSTextField!
    
    @IBOutlet weak var popUpButtonProvider: NSPopUpButton!
    
    let accountsManager = AccountsManager.init()
    
    let items: [String] = [
        ProviderManager.asString(provider: Provider.Facebook)!,
        ProviderManager.asString(provider: Provider.Twitter)!
    ]
    
    @IBAction func onButtonSaveAction(_ sender: NSButton) {
        let username = textFieldUsername.stringValue
        let provider = ProviderManager.PROVIDERS_LIST[popUpButtonProvider.indexOfSelectedItem]
        
        if !username.isEmpty {
            let account = accountsManager.addAccount(username: username, provider: provider)
            
            print("NewAccountViewController: Created account=\(account) with values username=\(username) provider=\(provider)")
            self.dismiss(self)
        } else {
            print("NewAccountViewController: Error username=\(username) provider=\(provider) must both be not empty!")
        }
    }
    
    @IBAction func onButtonCancelAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.popUpButtonProvider.addItems(withTitles: self.items)
    }
    
}
