//
//  ListView.swift
//  WatchLullabyRecipe WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/07/13.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var model = ViewModelWatch()
    
    @Binding var selection: Int
    
    var body: some View {
        
        VStack {
            List {
                let _ = print(self.model.session.receivedApplicationContext)
                ForEach(0..<self.model.messageList.count, id: \.self) { idx in
                    Button (action: {
                        selection = 1
                    }) {
                        HStack {
                            Image(systemName: "play.circle")
                            Text(self.model.messageList[idx][0])
                        }
                    }
                }
            }
        }
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(selection: .constant(1))
    }
}
