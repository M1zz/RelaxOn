//
//  Fresh.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import Foundation

#warning("name need changed")
struct fresh : Identifiable {
    var id : Int
    var name : String
    var price : String // description
    var image : String
}

var freshitems = [
fresh(id: 0, name: "Chinese_Gong", price: "chinese gong sound",image: "gong"),
fresh(id: 1, name: "Ocean_4", price: "ocean sound",image: "f2"),
fresh(id: 2, name: "Test", price: "this is test",image: "f3")
]
