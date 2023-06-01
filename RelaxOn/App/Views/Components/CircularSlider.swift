//
//  CircularSlider.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/05/25.
//
/**
 원하는 width 크기만큼의 원형 슬라이더를 만드는 View 객체
 SoundDetailView의 원형 슬라이더로
 사운드 커스텀에 사용되는 슬라이더
 */

import SwiftUI

struct CircularSlider: View {
    
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @State var angle: Double = Double.random(in: 0...360)
    @State var width: CGFloat
    @State private var currentFilterIndex = 0
    @State private var filter: AudioFilter
    @State private var filters: [AudioFilter] = []
    
    var imageName: String
    
    var isOnMove: Bool = true
    var angleChanged: (Double) -> Void
    var range: [Float]
    
    // 슬라이더의 angle값을 반환
    init(width: CGFloat, imageName: String, gestureType: Bool, range: [Float], filter: AudioFilter = .WaterDrop, angleChanged: @escaping (Double) -> Void) {
        self.width = width
        self.imageName = imageName
        self.isOnMove = gestureType
        self.range = range
        self._filter = State(initialValue: filter)
        self.angleChanged = angleChanged
    }
    
    var body: some View {
        
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 24)
            .foregroundColor(Color.systemGrey3)
            .rotationEffect(.init(degrees: -angle))
            .offset(x: width / 2)
            .rotationEffect(.init(degrees: angle))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        if isOnMove {
                            onDrag(value: value)
                        } else {
                            onMove(value: value)
                        }
                    })
            )
            .onAppear {
                if let filterArray = viewModel.filterDictionary[filter] {
                    filters.append(contentsOf: filterArray)
                }
                viewModel.isFilterChanged = {
                    AudioEngineManager.shared.updateFilter(newFilter: filter)
                }
            }
    }
    
    /**
     슬라이더의 각도를 구하는 함수
     수평선을 기준으로 상단은 + 180, 하단은 -180
     SnappedAngle은 정해진 각도로만 이동하기위한 함수
     */
    // 슬라이드형 움직임
    func onDrag(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy, vector.dx)
        let angle = radians * 180 / .pi
        self.angle = angle
        angleChanged(angle)
        print("\(angle)")
    }
    
    // 이동형 움직임
    func onMove(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - width / 2, vector.dx - width / 2)
        let angle = radians * 180 / .pi
        let snappedAngle = round(angle / 72) * 72

        if snappedAngle != self.angle {
            currentFilterIndex = (currentFilterIndex + 1) % filters.count
        }
        
        self.angle = Double(snappedAngle)
        angleChanged(angle)
        updateFilter()
    }
    
    func updateFilter() {
        if filters.count > 0 {
            print("currentFilterIndex: \(currentFilterIndex), filters.count: \(filters.count)")
            filter = filters[currentFilterIndex]
            if let isFilterChanged = viewModel.isFilterChanged {
                isFilterChanged()
                viewModel.updateFilter(filter: filter)
            }
        }
    }
}

struct CircularSlider_Previews: PreviewProvider {
    static var previews: some View {
        CircularSlider(width: 300, imageName: "filter", gestureType: true, range: [1.0]) { _ in }
    }
}
