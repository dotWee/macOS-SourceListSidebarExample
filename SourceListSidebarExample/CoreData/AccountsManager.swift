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
    
    let context: NSManagedObjectContext
    
    override init() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func addAccount(username: String, provider: Provider) -> Account? {
        guard let newEntity = NSEntityDescription.entity(forEntityName: accountEntityName, in: context) else {
            return nil
        }
        
        let newAccount = Account.init(entity: newEntity, insertInto: context)
        let newAccountId = UUID().uuidString
        
        newAccount.accountId = newAccountId
        newAccount.username = username
        newAccount.provider = Int64(ProviderManager.asInt(provider: provider))

        do {
            try context.save()
            return newAccount
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteAccount(account: Account) {
        context.delete(account)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        if let accounts = getAccounts() {
            for account in accounts {
                self.deleteAccount(account: account)
            }
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
