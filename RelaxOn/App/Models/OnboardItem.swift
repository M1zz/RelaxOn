//
//  OnboardItem.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/28.
//

import Foundation

enum OnboardButtonText: String {
    case `continue` = "계속"
    case start = "시작하기"
}

struct OnboardItem {
    let imageName: String
    let description: String
    let buttonText: String
    
    static func getAll() -> [OnboardItem] {
        return [
            OnboardItem(
                imageName: OnboardInfo.IconName.lamp.rawValue,
                description: OnboardInfo.IconText.lamp.rawValue,
                buttonText: OnboardButtonText.continue.rawValue
            ),
            OnboardItem(
                imageName: OnboardInfo.IconName.equalizerbutton.rawValue,
                description: OnboardInfo.IconText.equlizerbutton.rawValue,
                buttonText: OnboardButtonText.continue.rawValue
            ),
            OnboardItem(
                imageName: OnboardInfo.IconName.musicplayer.rawValue,
                description: OnboardInfo.IconText.musicplayer.rawValue,
                buttonText: OnboardButtonText.continue.rawValue
            ),
            OnboardItem(
                imageName: OnboardInfo.IconName.headphone.rawValue,
                description: OnboardInfo.IconText.headphone.rawValue,
                buttonText: OnboardButtonText.start.rawValue
            )
        ]
    }
}
