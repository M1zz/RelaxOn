//
//  Recipe.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import Foundation

#warning("name need changed")
struct recipe : Identifiable {
    
    var id : Int
    var name : String
    var author : String
    var image : String
    var authorpic : String
}

var recipeitems = [
recipe(id: 0, name: "Basil Pasta", author: "Karlien Nijhuis",image: "r1",authorpic: "rp1"),
recipe(id: 1, name: "Banana Rice", author: "Harmen Porter",image: "r2",authorpic: "rp2"),
recipe(id: 2, name: "Ramen", author: "Marama Peter",image: "r3",authorpic: "rp3")
]
