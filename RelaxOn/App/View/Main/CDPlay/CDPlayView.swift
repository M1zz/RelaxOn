//
//  CDPlayView.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import SwiftUI

struct CDPlayView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var cd: CD?
    @StateObject var cdPlayViewModel = CDPlayViewModel()
    @EnvironmentObject var cdManager: CDManager
    
    var body: some View {
        VStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("닫기")
            }
            Image("Garden")
                .resizable()
                .frame(width: 100, height: 100)
            Text(cd?.name ?? "error")
            HStack {
                Button {
                    cdPlayViewModel.clickedPreCD()
                } label: {
                    Text("이전")
                }
                Button {
                    cdPlayViewModel.clickedplayPause()
                } label: {
                    Text("멈추기")
                }
                Button {
                    cdPlayViewModel.clickedNextCD()
                } label: {
                    Text("다음")
                }
            }
        }
        .onAppear {
            cdPlayViewModel.setUp(playingCD: cd!, cdManager: cdManager)
        }
    }
}

//struct CDPlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        CDPlayView(cd: .constant(CD(name: "hi")))
//    }
//}
