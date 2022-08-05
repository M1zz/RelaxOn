//
//  CDWidgetEntry.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/05.
//

import Foundation
import WidgetKit

struct CDWidgetEntry: TimelineEntry {
    let date: Date
    
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
