//
//  CustomSegmentControlView.swift
//  LullabyRecipe
//
//  Created by 김연호 on 2022/07/23.
//

import SwiftUI

public struct CustomSegmentControlView: View {

    @Binding private var selection: Int
    @State private var segmentSize: CGSize = .zero
    @State private var itemTitleSizes: [CGSize] = []

    private let items: [String]

    public init(items: [String],
                selection: Binding<Int>) {
        self._selection = selection
        self.items = items
        self._itemTitleSizes = State(initialValue: [CGSize](repeating: .zero, count: items.count))
    }

    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                Color
                    .clear
                    .onAppear {
                        segmentSize = geometry.size
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: 1)

            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: xSpace) {
                        ForEach(0 ..< items.count, id: \.self) { index in
                            segmentItemView(for: index)
                        }
                    }
                    .padding(.bottom, 12)

                    // 선택된 요소 밑줄
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: selectedItemWidth, height: 3)
                        .offset(x: selectedItemHorizontalOffset(), y: 0)
                        .animation(Animation.linear(duration: 0.3))
                }
                .padding(.horizontal, xSpace)

            }
        }
    }

    private var selectedItemWidth: CGFloat {
        return itemTitleSizes.count > selection ? itemTitleSizes[selection].width : .zero
    }

    private func segmentItemView(for index: Int) -> some View {
        guard index < self.items.count else {
            return EmptyView().eraseToAnyView()
        }

        let isSelected = self.selection == index

        return
            Text(items[index])
            .font(.caption)
            .foregroundColor(isSelected ? .black : .gray)
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

    private var xSpace: CGFloat {
        guard !itemTitleSizes.isEmpty, !items.isEmpty, segmentSize.width != 0 else { return 0 }
        let itemWidthSum: CGFloat = itemTitleSizes.map { $0.width }.reduce(0, +).rounded()
        let space = (segmentSize.width - itemWidthSum) / CGFloat(items.count + 1)
        return max(space, 0)
    }

    private func selectedItemHorizontalOffset() -> CGFloat {
        guard selectedItemWidth != .zero, selection != 0 else { return 0 }

        let result = itemTitleSizes
            .enumerated()
            .filter { $0.offset < selection }
            .map { $0.element.width }
            .reduce(0, +)

        return result + xSpace * CGFloat(selection)
    }
}
