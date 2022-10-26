//
//  CustomNavigationLink.swift
//  RelaxOn
//
//  Created by hyo on 2022/09/16.
//

import SwiftUI

struct CustomNavigationLink<DestinationView, ContentView>: View where DestinationView: View, ContentView: View {
    var destination: DestinationView
    @Binding var isActive: Bool
    var label: () -> ContentView
    var hasIsActive: Bool
    
    init(destination: DestinationView, isActive: Binding<Bool>, label: @escaping () -> ContentView) {
        self.destination = destination
        self._isActive = isActive
        self.label = label
        self.hasIsActive = true
    }
    
    init(destination: DestinationView, label: @escaping () -> ContentView) {
        self.destination = destination
        self.label = label
        self._isActive = .constant(true)
        self.hasIsActive = false
    }
    
    var body: some View {
        if hasIsActive {
            NavigationLink(isActive: $isActive, destination: {
                destination
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: ArrowBackButton())
                    .navigationBarBackButtonHidden(true)
            }){
                label()
            }
        } else {
            NavigationLink(destination: {
                destination
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: ArrowBackButton())
                    .navigationBarBackButtonHidden(true)
            }){
                label()
            }
        }
      
    }
    
    struct ArrowBackButton: View {
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
        var body: some View {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("CD LIBRARY")
                        .font(.system(size: 17, weight: .regular))
                }.foregroundColor(Color.relaxDimPurple)
            }
        }
    }
}
