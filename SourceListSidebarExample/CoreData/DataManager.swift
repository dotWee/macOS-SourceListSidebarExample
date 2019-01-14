//
//  DataManager.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 14.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa

class DataManager: NSObject {

    static let sharedInstance = DataManager()
    let context: NSManagedObjectContext
    
    let accountEntityName = "Account"
    let accounts: Variable<[Account]?> = Variable([])
    
    let hostEntityName = "Host"
    let hosts: Variable<[Host]?> = Variable([])
    
    private override init() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        super.init()
        
        // Init observables and seed local data
        self.seed()
    }
    
    func seed() {
        self.seedHosts()
        self.seedAccounts()
    }
    
    func fetch(request: NSFetchRequest<NSFetchRequestResult>) -> Any? {
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Failed")
            return nil
        }
    }
}

extension DataManager: AccountsDataManager {
    
    func seedAccounts() {
        
        // Init observables
        self.notifyOnHostsChanged()
    }
    
    
    func notifyOnAccountsChanged() {
        self.accounts.value = self.getAllAccounts()
    }
    
    func addAccount(username: String, hostId: String) -> Account? {
        guard let newEntity = NSEntityDescription.entity(forEntityName: accountEntityName, in: context) else {
            return nil
        }
        
        let newAccount = Account.init(entity: newEntity, insertInto: context)
        let newAccountId = UUID().uuidString
        
        newAccount.accountId = newAccountId
        newAccount.username = username
        newAccount.hostId = hostId
        
        do {
            try context.save()
            self.notifyOnAccountsChanged()
        } catch {
            print(error)
        }
        
        return newAccount
    }
    
    func deleteAccount(account: Account) {
        context.delete(account)
        
        do {
            try context.save()
            self.notifyOnAccountsChanged()
        } catch {
            print(error)
        }
    }
    
    func deleteAllAccounts() {
        if let accounts = getAllAccounts() {
            for account in accounts {
                self.deleteAccount(account: account)
            }
        }
    }
    
    func getAllAccounts() -> [Account]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: accountEntityName)
        return self.fetch(request: request) as! [Account]?
    }
}

extension DataManager: HostsDataManager {
    
    func seedHosts() {
        
        // Init observables
        self.notifyOnHostsChanged()
        
        // Fill with sample data if empty
        if self.hosts.value == nil || (self.hosts.value?.count)! == 0 {
            let hostFacebook = self.addHost(name: "Facebook", url: "facebook.com")
            let hostTwitter = self.addHost(name: "Twitter", url: "twitter.com")
            
            print("HostsDataManager: seed hostFacebook=\(hostFacebook) hostTwitter=\(hostTwitter)")
        }
    }
    
    
    func notifyOnHostsChanged() {
        self.hosts.value = self.getAllHosts()
    }
    
    
    func addHost(name: String, url: String) -> Host? {
        guard let newEntity = NSEntityDescription.entity(forEntityName: hostEntityName, in: context) else {
            return nil
        }
        
        let newHost = Host.init(entity: newEntity, insertInto: context)
        let newHostId = UUID().uuidString
        
        newHost.hostId = newHostId
        newHost.name = name
        newHost.url = url
        
        do {
            try context.save()
            self.notifyOnHostsChanged()
        } catch {
            print(error)
        }
        
        return newHost
    }
    
    func deleteHost(host: Host) {
        context.delete(host)
        
        do {
            try context.save()
            self.notifyOnHostsChanged()
        } catch {
            print(error)
        }
    }
    
    func deleteAllHosts() {
        if let hosts = getAllHosts() {
            for host in hosts {
                self.deleteHost(host: host)
            }
        }
    }
    
    func getAllHosts() -> [Host]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: hostEntityName)
        return self.fetch(request: request) as! [Host]?
    }
}
