//
//  MainViewController.swift
//  SourceListSidebarExample
//
//  Created by Lukas Wolfsteiner on 11.01.19.
//  Copyright © 2019 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    
    let newAccountViewController = NSStoryboard.init(name: "Main", bundle: nil).instantiateController(withIdentifier: "NewAccountViewController") as! NewAccountViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        let mainWindowController = self.view.window?.windowController as! MainWindowController
        mainWindowController.mainSplitViewController = self
    }
    
    func onShowNewAccountSheet() {
        self.presentAsSheet(newAccountViewController)
    }
}
