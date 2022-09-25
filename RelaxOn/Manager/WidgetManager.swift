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
    let isPlaying: Bool
    let isRecentPlay: Bool
}

final class WidgetManager {
    enum KeyString {
        static let suiteName = "group.relaxOn.widget.appGroup"
        static let smallWidgetData = "smallWidgetData"
        static let widgetName = "RelaxOnWidget"
        static let lockScreenwidgetName = "RelaxOnLockScreenWidgetExtension"
        static let lockScreenWidgetData = "lockScreenWidgetData"
    }
    
    static let userDefaultsAppGroup = UserDefaults(suiteName: KeyString.suiteName)

    static func addMainSoundToWidget(data: SmallWidgetData) {
        if let encodedData = try? JSONEncoder().encode(data),
           let userDefaultsAppGroup {
            userDefaultsAppGroup.set(encodedData, forKey: KeyString.smallWidgetData)
        }
        WidgetCenter.shared.reloadTimelines(ofKind: KeyString.widgetName)
    }
    
    static func closeApp() {
        if let userDefaultsAppGroup,
           let savedData = userDefaultsAppGroup.object(forKey: KeyString.smallWidgetData) as? Data,
           let loadedData = try? JSONDecoder().decode(SmallWidgetData.self, from: savedData) {
            let savedSmallWidgetData = loadedData
            let data = SmallWidgetData(
                baseImageName: savedSmallWidgetData.baseImageName,
                melodyImageName: savedSmallWidgetData.melodyImageName,
                whiteNoiseImageName: savedSmallWidgetData.whiteNoiseImageName,
                name: savedSmallWidgetData.name,
                id: savedSmallWidgetData.id,
                isPlaying: savedSmallWidgetData.isPlaying,
                isRecentPlay: true)
            if let encodedData = try? JSONEncoder().encode(data) {
                userDefaultsAppGroup.set(encodedData, forKey: KeyString.smallWidgetData)
            }
            WidgetCenter.shared.reloadTimelines(ofKind: KeyString.widgetName)
        }
    }
    
    static func setupTimerToLockScreendWidget(settedSeconds: Double) {
        if let userDefaultsAppGroup {
            userDefaultsAppGroup.set(settedSeconds, forKey: KeyString.lockScreenWidgetData)
         }
        WidgetCenter.shared.reloadTimelines(ofKind: KeyString.lockScreenwidgetName)
     }
    
    static func getURL(id: Int) -> URL? {
        if let url = URL(string: "RelaxOn:///MixedSound\(id)") {
            return url
        } else {
            return nil
        }
    }
}
