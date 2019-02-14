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
    var hosts: [Host] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here
        self.outlineView.delegate = self
        self.outlineView.dataSource = self
        
        // Listen on accounts change
        DataManager.sharedInstance.accounts.asObservable()
            .subscribe(onNext: { (accounts) in
                print("MainSidebarViewController: onNext accounts=\(String(describing: accounts))")
                self.onAccountsDataChanged(accounts: accounts)
            })
            .disposed(by: (NSApplication.shared.delegate as! AppDelegate).mainDisposeBag)
        self.onAccountsDataChanged(accounts: DataManager.sharedInstance.getAllAccounts())
        
        // Listen on hosts change
        DataManager.sharedInstance.hosts.asObservable()
            .subscribe(onNext: { (hosts) in
                print("MainSidebarViewController: onNext hosts=\(String(describing: hosts))")
                self.onHostsDataChanged(hosts: hosts)
            })
            .disposed(by: (NSApplication.shared.delegate as! AppDelegate).mainDisposeBag)
        self.onHostsDataChanged(hosts: DataManager.sharedInstance.getAllHosts())
    }
    
    override func viewDidAppear() {
        self.mainWindowController = self.view.window?.windowController as? MainWindowController
        self.mainWindowController!.mainSidebarViewController = self
    }
    
    private func onHostsDataChanged(hosts: [Host]?) {
        self.hosts = hosts ?? []
        
        self.outlineView.reloadData()
        expandAll()
    }
    
    private func onAccountsDataChanged(accounts: [Account]?) {
        self.accounts = accounts ?? []
        
        self.outlineView.reloadData()
        expandAll()
    }
    
    private func expandAll() {
        // Expand all by default
        for host in self.hosts {
            self.outlineView.expandItem(host)
        }
    }
}

extension MainSidebarViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let host = item as? Host {
            let accountsOfHost = self.accounts.filter() {
                return ($0 as Account).hostId == host.hostId
            }
            
            return accountsOfHost.count
        } else {
            return hosts.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let host = item as? Host {
            let accountsOfHost = self.accounts.filter() {
                return ($0 as Account).hostId == host.hostId
            }
            
            return accountsOfHost[index]
        }
        
        return hosts[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let host = item as? Host {
            let accountsOfHost = self.accounts.filter() {
                return ($0 as Account).hostId == host.hostId
            }
            
            return accountsOfHost.count > 0
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
        
        if let host = item as? Host {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                textField.stringValue = host.name!
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
            }
        } else if let host = outlineView.item(atRow: selectedIndex) as? Host {
            if self.mainWindowController != nil {
                self.mainWindowController!.selectedHost.value = host
            }
        }
    }
}
