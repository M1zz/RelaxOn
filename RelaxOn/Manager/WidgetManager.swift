//
//  WidgetManager.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/06.
//

import SwiftUI
import WidgetKit

struct SmallWidgetData: Codable {
    let imageName: String
    let name: String
    let id: Int
}


class WidgetManager {
    static func addMainSoundToWidget(imageName: String, name: String, id: Int) {
        let data = SmallWidgetData(imageName: imageName, name: name, id: id)
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults(suiteName: "group.widget.relaxOn")!.set(encodedData, forKey: "smallWidgetData")
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "RelaxOnWidget")
    }
}
