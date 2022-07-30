//
//  TestNavigateView.swift
//  LullabyRecipe
//
//  Created by 김연호 on 2022/07/27.
//
//
import SwiftUI

struct TestNavigateView: View {

    var body: some View {
        NavigationView {
            NavigationLink(destination: StudioView()) {
                Text("Move to StuioView")
            }.navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .navigationTitle("")
        }
    }
}

struct TestNavigateView_Previews: PreviewProvider {
    static var previews: some View {
        TestNavigateView()
    }
}
