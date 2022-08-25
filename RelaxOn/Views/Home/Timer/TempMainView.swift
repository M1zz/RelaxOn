//
//  TempMainView.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI

struct TempMainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TimerNavigationLinkView()
                    .navigationBarTitle("HOW LONG..") // 백버튼 텍스트 내용
                    .navigationBarHidden(true)
                Spacer()
            }
        }
    }
}

// MARK: - PREVIEW
struct TempMainView_Previews: PreviewProvider {
    static var previews: some View {
        TempMainView()
    }
}
