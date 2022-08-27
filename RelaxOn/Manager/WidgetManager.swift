//
//  WidgetManager.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/06.
//

import WidgetKit

struct SmallWidgetData: Codable {
    let baseImageName: String
    let melodyImageName: String
    let whiteNoiseImageName: String
    let name: String
    let id: Int
}

final class WidgetManager {
    static let suiteName = "group.relaxOn.widget.appGroup"
    static let smallWidgetData = "smallWidgetData"
    static let widgetName = "RelaxOnWidget"
    
    static func addMainSoundToWidget(baseImageName: String, melodyImageName: String, whiteNoiseImageName: String, name: String, id: Int) {
        let data = SmallWidgetData(baseImageName: baseImageName, melodyImageName: melodyImageName, whiteNoiseImageName: whiteNoiseImageName, name: name, id: id)
        if let encodedData = try? JSONEncoder().encode(data),
           let UserDefaultsAppGroup = UserDefaults(suiteName: suiteName) {
            UserDefaultsAppGroup.set(encodedData, forKey: smallWidgetData)
        }
        WidgetCenter.shared.reloadTimelines(ofKind: widgetName)
    }
    
    static func getURL(id: Int) -> URL? {
        if let url = URL(string: "RelaxOn:///MixedSound\(id)") {
            return url
        } else {
            return nil
        }
    }
}
