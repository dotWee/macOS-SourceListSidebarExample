//
//  HostsManager.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 12.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa
import AppKit

class HostsManager {
    static let sharedInstance = HostsManager()
    
    let hostEntityName = "Host"
    let context: NSManagedObjectContext
    let hosts: Variable<[Host]?> = Variable([])
    
    init() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
        self.hosts.value = self.getHosts()
        
        // Fill with sample data if empty
        if self.getHosts() == nil || (self.getHosts()?.count)! == 0 {
            let hostFacebook = self.addHost(name: "Facebook", url: "facebook.com")
            let hostTwitter = self.addHost(name: "Twitter", url: "twitter.com")
            print("HostsManager: init hostFacebook=\(hostFacebook) hostTwitter=\(hostTwitter)")
        }
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
            
            self.hosts.value = getHosts()
            return newHost
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteHost(host: Host) {
        context.delete(host)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        self.hosts.value = getHosts()
    }
    
    func deleteAll() {
        if let hosts = getHosts() {
            for host in hosts {
                self.deleteHost(host: host)
            }
        }
        
        self.hosts.value = getHosts()
    }
    
    func getHosts() -> [Host]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: hostEntityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request) as! [Host]
            self.hosts.value = result
            return result
        } catch {
            print("Failed")
            return nil
        }
    }
}
