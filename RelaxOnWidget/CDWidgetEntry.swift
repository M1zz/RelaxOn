//
//  CDWidgetEntry.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/05.
//

import Foundation
import WidgetKit

struct CDWidgetEntry: TimelineEntry {
    // TimelineEntry 프로토콜은 date라는 프로퍼티를 필수적으로 요구함
    let date: Date // WidgetKit이 widget을 rendering하는 date
    
    let imageName: String
    var id: Int
    var name: String
    var url: URL
    
    init(date: Date = Date(), imageName: String = "Recipe5", id: Int = 100, name: String = "tempWidget") {
        self.date = date
        self.imageName = imageName
        self.id = id
        self.name = name
        self.url = URL(string: "RelaxOn:///\(id)+\(name)")!
    }
}

extension CDWidgetEntry {
    static var sample = CDWidgetEntry()
}
