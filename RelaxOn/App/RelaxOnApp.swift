//
//  RelaxOnApp.swift
//  RelaxOn
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI

@main
struct RelaxOnApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            CdLibraryView()
        }
    }
}
