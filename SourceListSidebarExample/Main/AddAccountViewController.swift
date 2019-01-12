//
//  AddAccountViewController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa
import AppKit

class AddAccountViewController: NSViewController {

    @IBOutlet weak var textFieldUsername: NSTextField!
    
    @IBOutlet weak var buttonOk: NSButton!
    
    @IBOutlet weak var popUpButtonProvider: NSPopUpButton!
    
    let disposeBag = DisposeBag.init()
    let accountsManager = AccountsManager.init()
    
    let items: [String] = [
        ProviderManager.asString(provider: Provider.Facebook)!,
        ProviderManager.asString(provider: Provider.Twitter)!
    ]
    
    @IBAction func onButtonSaveAction(_ sender: NSButton) {
        let username = textFieldUsername.stringValue
        let provider = ProviderManager.PROVIDERS_LIST[popUpButtonProvider.indexOfSelectedItem]
        
        let account = accountsManager.addAccount(username: username, provider: provider)
        
        print("NewAccountViewController: Created account=\(String(describing: account)) with values username=\(username) provider=\(provider)")
        self.dismiss(self)
    }
    
    @IBAction func onButtonCancelAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.popUpButtonProvider.addItems(withTitles: self.items)
        self.textFieldUsername
            .rx.text
            .distinctUntilChanged()
            .subscribe(onNext: { (usernameValue) in
                print("onNext: \(String(describing: usernameValue))")
                
                self.buttonOk.isEnabled = usernameValue != nil && !(usernameValue?.isEmpty)!
            }).disposed(by: disposeBag)
    }
    
}
