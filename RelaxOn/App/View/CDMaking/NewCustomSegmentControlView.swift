//
//  NewCustomSegmentControlView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/10/31.
//
//
import SwiftUI

public struct NewCustomSegmentControlView: View {
    // MARK: - State Properties
    @State private var segmentSize: CGSize = .zero
    @State private var itemTitleSizes: [CGSize] = []
    @Binding private var selection: Int

    // MARK: - General Properties
    private let items: [LocalizedStringKey]

    private var selectedItemWidth: CGFloat {
        return itemTitleSizes.count > selection ? itemTitleSizes[selection].width : .zero
    }

    // MARK: - Methods
    private func segmentItemView(for index: Int) -> some View {
        guard index < self.items.count else {
            return EmptyView().eraseToAnyView()
        }

        let isSelected = self.selection == index

        return Text(items[index])
            .font(.caption)
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
        guard selectedItemWidth != .zero, selection != 0 else { return 30 }

        return 30 + (DeviceFrame.screenWidth * 0.295) * CGFloat(selection) + ( CGFloat(selection) == 2 ? DeviceFrame.screenWidth * 0.03 : 0 )
    }

    // MARK: - Life Cycles
    init(items: [MaterialType],
                selection: Binding<Int>) {
        self._selection = selection
        self.items = items.map{LocalizedStringKey($0.rawValue)}
        self._itemTitleSizes = State(initialValue: [CGSize](repeating: .zero, count: items.count))
    }

    public var body: some View {
        ZStack {

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< items.count, id: \.self) { index in
                            segmentItemView(for: index)
                                .padding(.leading,
                                         index == 0 ? 58 : ( index == 1 ? DeviceFrame.screenWidth * 0.19 : DeviceFrame.screenWidth * 0.16 ))
                        }
                    }
                    .padding(.bottom, 5)

                    // 선택된 요소 밑줄
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 88, height: 1)
                        .offset(x: selectedItemHorizontalOffset(), y: 0)
                        .animation(Animation.linear(duration: 0.3), value: selectedItemWidth)

                }
                Spacer()
            }
        }
    }
}
