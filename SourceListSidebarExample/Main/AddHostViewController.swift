//
//  AddHostViewController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 15.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import RxCocoa
import RxSwift
import Cocoa

class AddHostViewController: NSViewController {
    
    @IBOutlet weak var buttonOk: NSButton!
    
    @IBOutlet weak var textFieldHostName: NSTextField!
    
    @IBOutlet weak var textFieldHostUrl: NSTextField!
    
    @IBAction func buttonOkActionHandler(_ sender: NSButton) {
        let name = textFieldHostName.stringValue
        let url = textFieldHostUrl.stringValue
        let host = DataManager.sharedInstance.addHost(name: name, url: url)
        
        print("AddHostViewController: Created host=\(String(describing: host)) with values name=\(name) url=\(url) hostId=\(host?.hostId)")
        
        // Clear view
        self.textFieldHostName.stringValue = ""
        self.textFieldHostUrl.stringValue = ""
        
        self.dismiss(self)
    }
    
    @IBAction func buttonCancelActionHandler(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        
        _ = self.textFieldHostName
            .rx.text
            .distinctUntilChanged()
            .asObservable()
            .subscribe(onNext: { (nameValue) in
                print("AddHostViewController: onNext nameValue=\(String(describing: nameValue))")
                self.onHostDataChange()
            })
            .disposed(by: appDelegate.mainDisposeBag)
        
        _ = self.textFieldHostUrl
            .rx.text
            .distinctUntilChanged()
            .asObservable()
            .subscribe(onNext: { (urlValue) in
                print("AddHostViewController: onNext urlValue=\(String(describing: urlValue))")
                self.onHostDataChange()
            }).disposed(by: appDelegate.mainDisposeBag)
    }
    
    private func onHostDataChange() {
        let nameValue = textFieldHostName.stringValue
        let urlValue = textFieldHostUrl.stringValue
        
        self.buttonOk.isEnabled = !urlValue.isEmpty && !nameValue.isEmpty
    }
    
}
