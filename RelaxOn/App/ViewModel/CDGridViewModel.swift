//
//  CDGridViewModel.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import Foundation

final class CDGridViewModel: ObservableObject {
    #warning("CDManager 주솟값을 가지고 있겠지.....???? 부디 !!!")
    @Published var cdManager: CDManager?
    @Published var CDList : [CD]?
    
    func setUp(cdManager: CDManager) {
        self.cdManager = cdManager
        self.CDList = cdManager.CDList
    }

    func tabRemoveButton() {
        print(#function)
    }

    func playCD() {
        print(#function)
    }
}
