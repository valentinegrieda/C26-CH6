//
//  DraftView.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 14/09/26.
//


import SwiftUI
import SwiftData

struct DraftView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DraftModel.date, order: .reverse) private var allEntries: [DraftModel]
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""
    @State private var searchText: String = ""

    private var entries: [DraftModel] {
        allEntries.filter { $0.userId.uuidString == loggedInUserId }
    }

    private var filteredEntries: [DraftModel] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return entries }
        return entries.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Draft")
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding(.top, 42)
                    .padding(.bottom, 20)

                SearchBarView(text: $searchText)
                    .padding(.bottom, 20)

                ScrollView {

                    LazyVStack(spacing: 24) {
                        ForEach(filteredEntries) { entry in
                            NavigationLink {
                                DetailDraftView(entry: entry)
                            } label: {
                                DiaryRowDraftView(entry: entry)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(20)
                }
                .scrollIndicators(.hidden)
                
                
            }
            .padding(20)
            .padding(.bottom, 80)
            .vibrantLinearBackground()
            /*.safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 90)
            }*/
            .overlay {
                if filteredEntries.isEmpty {
                    if entries.isEmpty {
                        ContentUnavailableView(
                            "There is no draft",
                            systemImage: "square.and.pencil",
                            description: Text("Unfinished writing will be saved here")
                        )
                        .foregroundStyle(.white)
                    } else {
                        ContentUnavailableView(
                            "No results found",
                            systemImage: "magnifyingglass",
                            description: Text("Try a different search term")
                        )
                        .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    //ListView()
      //  .modelContainer(for: DiaryModel.self, inMemory: true)
    
        DraftView()
            .modelContainer(for: DraftModel.self, inMemory: true)
    
}
