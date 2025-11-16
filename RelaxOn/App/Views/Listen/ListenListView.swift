//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

/**
 커스텀 음원 목록이 노출되는 View
 하단 플레이어 바를 통해 음원 재생, 정지 기능
 */
struct ListenListView: View {

    @EnvironmentObject var viewModel: CustomSoundViewModel
    @State private var searchText = ""

    @State private var selectedFile = CustomSound()
    @State private var isShowingSheet = false
    @State private var isShowingPlayer = false
    @State private var editingSound: CustomSound? = nil
    @State private var isShowingEditView = false
    @State private var isShowingCreateModal = false
    @State private var isShowingSettings = false
    
    // MARK: - Body
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(TabItems.listen.rawValue)
                    .foregroundColor(Color(.TitleText))
                    .font(.system(size: 24, weight: .bold))

                Spacer()

                // 설정 버튼
                Button(action: {
                    isShowingSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(.Text).opacity(0.6))
                }
                .padding(.trailing, 12)

                // 새 사운드 만들기 버튼
                Button(action: {
                    isShowingCreateModal = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(.PrimaryPurple))
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 4)
            
            if !viewModel.customSounds.isEmpty {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
            }

            if viewModel.customSounds.isEmpty {
                // 빈 상태 UI
                emptyStateView()
            } else {
                List {
                    ForEach(viewModel.filteredSounds) { file in
                    ListenListCell(customSound: file)
                        .onTapGesture {
                            viewModel.selectedSound = file
                            withAnimation {
                                isShowingPlayer = true
                            }
                            if viewModel.isPlaying {
                                viewModel.stopSound()
                                viewModel.play(with: file)
                            } else {
                                viewModel.play(with: file)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                if let index = viewModel.customSounds.firstIndex(where: { $0.id == file.id }) {
                                    viewModel.remove(at: index)
                                }
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }

                            Button {
                                editingSound = file
                                isShowingEditView = true
                            } label: {
                                Label("편집", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                    .listRowBackground(Color(.DefaultBackground))
                    .listRowSeparator(.hidden)
                }
            }
            
            if isShowingPlayer {
                Button {
                    isShowingSheet = true
                } label: {
                    SoundPlayerBottomView()
                }
                .sheet(isPresented: $isShowingSheet, onDismiss: {
                    isShowingSheet = false
                }) {
                    SoundPlayerFullModalView()
                }
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                    value: 1.0
                )
            }
        }
        .listStyle(PlainListStyle())
        .background(Color(.DefaultBackground))

        .sheet(isPresented: $isShowingEditView) {
            if let editing = editingSound {
                NavigationView {
                    SoundDetailView(
                        isTutorial: false,
                        originalSound: OriginalSound(
                            name: editing.category.displayName,
                            filter: editing.filter,
                            category: editing.category
                        ),
                        editingSound: editing
                    )
                }
            }
        }

        .sheet(isPresented: $isShowingCreateModal) {
            createSoundModal()
        }

        .sheet(isPresented: $isShowingSettings) {
            NavigationStack {
                TimerMainView()
                    .navigationTitle("타이머")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("닫기") {
                                isShowingSettings = false
                            }
                        }
                    }
            }
        }

        .onAppear {
            selectedFile = viewModel.lastSound
            viewModel.loadSound()
        }
    }

    // MARK: - Helper Views

    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "music.note.list")
                    .font(.system(size: 64))
                    .foregroundColor(Color(.Text).opacity(0.3))

                VStack(spacing: 8) {
                    Text("저장된 사운드가 없어요")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(.TitleText))

                    Text("나만의 첫 사운드를 만들어보세요")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.Text).opacity(0.6))
                }

                Button(action: {
                    isShowingCreateModal = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text("첫 사운드 만들기")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color(.PrimaryPurple))
                    .cornerRadius(12)
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.DefaultBackground))
    }

    @ViewBuilder
    private func createSoundModal() -> some View {
        NavigationStack {
            SoundListView()
                .navigationTitle("새 사운드 만들기")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("닫기") {
                            isShowingCreateModal = false
                        }
                    }
                }
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}
