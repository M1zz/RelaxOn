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
    let date: Date // WidgetKit이 widget을 rendering할 date
    #warning("title 없애기")
    let imageName: String
    var id: Int
    var name: String
    var url: URL
    
    init(date: Date, imageName: String, id: Int, name: String) {
        self.date = Date()
        self.imageName = imageName
        self.id = id
        self.name = name
        self.url = URL(string: "RelaxOn:///\(id)+\(name)")!
    }
}

extension CDWidgetEntry {
    static var sample = CDWidgetEntry(date: Date(), imageName: "Recipe5", id: 0, name: "firstWidget")
}
