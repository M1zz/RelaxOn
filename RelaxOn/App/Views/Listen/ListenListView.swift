//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct ListenListView: View {
    var body: some View {
        // TODO: 1. 커스텀 셀 구현 - 이미지 + 제목 + 재생/정지 버튼
        // TODO: 2. 밀어서 Remove
        
        List {
            Text("My Water Drop")
            Text("Peaceful Water Sound")
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}
