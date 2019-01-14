//
//  AccountsDataManager.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 14.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

protocol AccountsDataManager {
    
    func addAccount(username: String, hostId: String) -> Account?
    func deleteAccount(account: Account)
    
    func getAllAccounts() -> [Account]?
    func deleteAllAccounts()
    
    func notifyOnAccountsChanged()
    
    // For debug usages
    func seedAccounts()
}
