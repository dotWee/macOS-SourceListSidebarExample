//
//  AccountsManager.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class AccountsManager: NSObject {
    let accountEntityName = "Account"
    let accountValueKeyAccountId = "accountId"
    let accountValueKeyUsername = "username"
    let accountValueKeyProvider = "provider"
    
    let context: NSManagedObjectContext
    
    override init() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func addAccount(username: String, provider: Provider) -> String? {
        guard let newEntity = NSEntityDescription.entity(forEntityName: accountEntityName, in: context) else {
            return nil
        }
        
        let newAccount = NSManagedObject(entity: newEntity, insertInto: context)
        
        let accountId = UUID().uuidString
        newAccount.setValue(accountId, forKey: accountValueKeyAccountId)
        newAccount.setValue(username, forKey: accountValueKeyUsername)
        newAccount.setValue(ProviderManager.asInt(provider: provider), forKey: accountValueKeyProvider)

        do {
            try context.save()
            return accountId
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteAccount(accountId: String) -> Bool? {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let context = appDelegate.persistentContainer.viewContext
        if let accounts = getAccounts() {
            
            for account in accounts {
                if account.value(forKey: accountValueKeyAccountId) as! String == accountId {
                    
                    // account to delete
                    context.delete(account)
                    return true
                }
            }
        }
        
        return nil
    }
    
    func deleteAll() -> Bool? {
        if let accounts = getAccounts() {
            for account in accounts {
                context.delete(account)
            }
            
            return true
        } else {
            return nil
        }
    }
    
    func getAccounts() -> [Account]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: accountEntityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request) as! [Account]
            return result
        } catch {
            print("Failed")
            return nil
        }
    }
}
