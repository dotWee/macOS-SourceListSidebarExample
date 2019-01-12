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
    
    var names: [String] = []
    var hosts: [Host] = []
    
    @IBAction func onButtonSaveAction(_ sender: NSButton) {
        let username = textFieldUsername.stringValue
        let hostId = hosts[self.popUpButtonProvider.indexOfSelectedItem].hostId
        let account = AccountsManager.sharedInstance.addAccount(username: username, hostId: hostId!)
        
        print("AddAccountViewController: Created account=\(String(describing: account)) with values username=\(username) hostId=\(hostId)")
        self.dismiss(self)
    }
    
    @IBAction func onButtonCancelAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        if let hosts = HostsManager.sharedInstance.getHosts() {
            for host in hosts {
                self.names.append(host.name!)
                self.hosts.append(host)
                
                self.popUpButtonProvider.addItem(withTitle: host.name!)
            }
        }
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        self.textFieldUsername
            .rx.text
            .distinctUntilChanged()
            .subscribe(onNext: { (usernameValue) in
                print("AddAccountViewController: onNext username=\(String(describing: usernameValue))")
                self.buttonOk.isEnabled = usernameValue != nil && !(usernameValue?.isEmpty)!
            }).disposed(by: appDelegate.mainDisposeBag)
    }
    
}
