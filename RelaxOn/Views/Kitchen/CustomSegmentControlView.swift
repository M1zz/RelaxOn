//
//  CustomSegmentControlView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/07/23.
//

import SwiftUI

public struct CustomSegmentControlView: View {
    // MARK: - State Properties
    @State private var segmentSize: CGSize = .zero
    @State private var itemTitleSizes: [CGSize] = []
    @Binding private var selection: Int

    // MARK: - General Properties
    private let items: [LocalizedStringKey]
    
    private var selectedItemWidth: CGFloat {
        return itemTitleSizes.count > selection ? itemTitleSizes[selection].width : .zero
    }
    
//    private var xSpace: CGFloat {
//        let itemWidthSum: CGFloat = itemTitleSizes.map { $0.width }.reduce(0, +).rounded()
//        let space = (segmentSize.width - itemWidthSum) / CGFloat(items.count - 1)
//        return max(space, 0)
//
//    }
    
    // MARK: - Methods
    private func segmentItemView(for index: Int) -> some View {
        guard index < self.items.count else {
            return EmptyView().eraseToAnyView()
        }

        let isSelected = self.selection == index

        return Text(items[index])
            .font(.body)
            .foregroundColor(isSelected ? .white : .gray)
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self) {
                itemTitleSizes[index] = $0
            }
            .onTapGesture { onItemTap(index: index) }
            .eraseToAnyView()
    }

    private func onItemTap(index: Int) {
        guard index < self.items.count else { return }
        self.selection = index
    }

    private func selectedItemHorizontalOffset() -> CGFloat {
        guard selectedItemWidth != .zero, selection != 0 else { return 20 }
        // selected Item이전까지의 select된 title의 width값의 합
        let result = itemTitleSizes
            .enumerated()
            .filter { $0.offset < selection }
            .map { $0.element.width }
            .reduce(0, +)

        return 20 + 36 * CGFloat(selection) + result
//        return result + xSpace * CGFloat(selection)
    }
    
    // MARK: - Life Cycles
    public init(items: [String],
                selection: Binding<Int>) {
        self._selection = selection
        self.items = items.map{LocalizedStringKey($0)}
        self._itemTitleSizes = State(initialValue: [CGSize](repeating: .zero, count: items.count))
    }

    public var body: some View {
        ZStack {

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< items.count, id: \.self) { index in
                            segmentItemView(for: index)
                                .padding(.leading, index == 0 ? 20 : 36)
                        }
                    }
                    .padding(.bottom, 2)

                    // 선택된 요소 밑줄
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: selectedItemWidth, height: 2)
                        .offset(x: selectedItemHorizontalOffset(), y: 0)
                        .animation(Animation.linear(duration: 0.3), value: selectedItemWidth)

                }
//                .padding(.horizontal, 36)
                Spacer()
            }

        }
    }
}
