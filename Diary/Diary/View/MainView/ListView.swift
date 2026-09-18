//
//  ListView.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 14/09/26.
//


import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DiaryModel.date, order: .reverse) private var allEntries: [DiaryModel]
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""
    @State private var searchText: String = ""

    private var entries: [DiaryModel] {
        allEntries.filter { $0.userId.uuidString == loggedInUserId }
    }

    private var filteredEntries: [DiaryModel] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return entries }
        return entries.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("List")
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
                                DetailListView(entry: entry)
                            } label: {
                                DiaryRowListView(entry: entry)
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
                            "There is no diary",
                            systemImage: "book.closed",
                            description: Text("Press the plus button to write a new diary")
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
    ListView()
        .modelContainer(for: DiaryModel.self, inMemory: true)
}
