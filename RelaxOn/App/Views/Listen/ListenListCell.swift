//
//  ListenListCell.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import SwiftUI

/**
 커스텀 음원의 각 정보가 셀 안에 노출되는 View
 */
struct ListenListCell: View {
    // MARK: - Properties
    
    // TODO: 삭제 예정 -> viewModel로 관리
    var title: String
    var ImageName: String
    
    // TODO: 삭제 예정 -> enum으로 관리
    var PlayButtonImageName: String = "play.fill"
    var PauseButtonImageName: String = "pause.fill"
    
    var body: some View {
        HStack {
            Image(ImageName)
                .frame(width: 60, height: 60)
                .background(.foreground.opacity(0.08)).cornerRadius(10)
            Text(title)
                .font(.body)
                .bold()
            Spacer()
            Button(action: {
                // TODO: 재생 & 정지 토글 기능
            }) {
                Image(systemName: PauseButtonImageName)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
            }
        }
    }
}
struct ListenListCell_Previews: PreviewProvider {
    static var previews: some View {
        ListenListCell(title: "타이틀", ImageName: "play.fill")
    }
}
