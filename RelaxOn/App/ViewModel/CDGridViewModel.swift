//
//  CDGridViewModel.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import Foundation

final class CDGridViewModel: ObservableObject {
    let CDList : [CD]
    
    init(CDList: [CD]) {
        self.CDList = CDList
    }

    func tabRemoveButton() {
        print(#function)
    }

    func playCD() {
        print(#function)
    }
}
