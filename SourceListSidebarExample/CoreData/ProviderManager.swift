//
//  ProviderManager.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class ProviderManager: NSObject {
    
    static let PROVIDERS_LIST = [
        Provider.Facebook,
        Provider.Twitter
    ]

    static func asString(provider: Provider) -> String? {
        switch provider {
        case Provider.Facebook:
            return "Facebook"
            
        case Provider.Twitter:
            return "Twitter"
            
        default:
            return nil
        }
    }
    
    static func asStringFromInt(provider: Int) -> String? {
        switch ProviderManager.fromInt(integer: provider) {
        case Provider.Facebook:
            return "Facebook"
            
        case Provider.Twitter:
            return "Twitter"
            
        default:
            return nil
        }
    }
    
    static func asUrl(provider: Provider) -> String? {
        switch provider {
        case Provider.Facebook:
            return "facebook.com"
            
        case Provider.Twitter:
            return "twitter.com"
            
        default:
            return nil
        }
    }
    
    static func asInt(provider: Provider) -> Int {
        switch provider {
        case Provider.Facebook:
            return 0
            
        case Provider.Twitter:
            return 1
            
        default:
            return -1
        }
    }
    
    static func fromInt(integer: Int) -> Provider {
        return ProviderManager.PROVIDERS_LIST[integer]
        
    }
}
