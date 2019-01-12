//
//  MainSidebarViewController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa
import AppKit

class MainSidebarViewController: NSViewController {

    @IBOutlet weak var scrollView: NSScrollView!
    
    @IBOutlet weak var clipView: NSClipView!
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    var mainWindowController: MainWindowController? = nil
    var accounts: [Account] = []
    var providers: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.providers.removeAll()
        for provider in ProviderManager.PROVIDERS_LIST {
            providers.append(ProviderManager.asInt(provider: provider))
        }
        
        // Do view setup here
        self.accounts = AccountsManager.sharedInstance.accounts.value ?? []
        AccountsManager.sharedInstance.accounts.asObservable()
            .subscribe(onNext: { (accounts) in
                print("MainSidebarViewController: onNext accounts=\(String(describing: accounts))")
                if accounts != nil {
                    self.accounts = accounts!
                }
                self.outlineView.reloadData()
            }).disposed(by: (NSApplication.shared.delegate as! AppDelegate).mainDisposeBag)
        
        self.outlineView.delegate = self
        self.outlineView.dataSource = self
    }
    
    override func viewDidAppear() {
        self.mainWindowController = self.view.window?.windowController as? MainWindowController
        self.mainWindowController!.mainSidebarViewController = self
    }
}

extension MainSidebarViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let provider = item as? Int {
            let accountsOfProvider = self.accounts.filter() {
                return ($0 as Account).provider == provider
            }
            
            return accountsOfProvider.count
        } else {
            return providers.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let provider = item as? Int {
            let accountsOfProvider = self.accounts.filter() {
                return ($0 as Account).provider == provider
            }
            
            return accountsOfProvider[index]
        }
        
        return providers[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let provider = item as? Int {
            let accountsOfProvider = self.accounts.filter() {
                return ($0 as Account).provider == provider
            }
            
            return accountsOfProvider.count > 0
        }
        
        return false
    }
}

extension MainSidebarViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, item: Any) -> Bool {
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        
        if let provider = item as? Int {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                textField.stringValue = ProviderManager.asStringFromInt(provider: provider)!
                //textField.sizeToFit()
            }
            
        } else if let account = item as? Account {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as? NSTableCellView
            
            if let textField = view?.textField {
                //5
                textField.stringValue = account.username!
                //textField.sizeToFit()
            }
        } else {
            print("MainSidebarViewController: Unknown type item=\(item)")
        }
        
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        
        let selectedIndex = outlineView.selectedRow
        if let account = outlineView.item(atRow: selectedIndex) as? Account {
            if self.mainWindowController != nil {
                self.mainWindowController!.selectedAccount.value = account
            } else {
                print("MainSidebarViewController: Error, couldn't send changed selectedAccount")
            }
        }
    }
}
