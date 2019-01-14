//
//  HostsDataManager.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 14.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

protocol HostsDataManager {
    
    func addHost(name: String, url: String) -> Host?
    func deleteHost(host: Host)
    
    func getAllHosts() -> [Host]?
    func deleteAllHosts()
    
    func notifyOnHostsChanged()
    
    // For debug usages
    func seedHosts()
}
