//
//  RelaxOnApp.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import SwiftUI

@main
struct RelaxOnApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            PageView()
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
