//
//  HomeView.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 10/09/26.
//

import SwiftUI
import SwiftData


struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DiaryModel.date, order: .reverse) private var allEntries: [DiaryModel]
    @Query(sort: \DraftModel.date, order: .reverse) private var allDraftEntries: [DraftModel]
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""

    private var entries: [DiaryModel] {
        allEntries.filter { $0.userId.uuidString == loggedInUserId }
    }

    private var draftentries: [DraftModel] {
        allDraftEntries.filter { $0.userId.uuidString == loggedInUserId }
    }

    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 30) {
                
                Text("Home")
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding(.top,42)
                
                if entries.isEmpty {

                    Spacer()

                    VStack(alignment: .leading, spacing: 50) {
                        VStack(alignment: .leading) {
                            Text("No")
                            Text("Diary")
                            Text("Yet")

                            Divider()

                        }
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                }

                else {
                    VStack(alignment: .leading, spacing:20){
                        Text("Diary Entries")
                            .font(.default)
                            .foregroundStyle(.white)
                            //.padding(.top,42)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(entries) { entry in
                                    NavigationLink {
                                        DetailListView(entry: entry)
                                    } label: {
                                        DiaryRowHomeListView(entry: entry)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                        }
                        
                        if !draftentries.isEmpty {
                            Text("Draft Entries")
                                .font(.default)
                                .foregroundStyle(.white)
                                //.padding(.top,42)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(draftentries) { entry in
                                        NavigationLink {
                                            DetailDraftView(entry: entry)
                                        } label: {
                                            DiaryRowHomeDraftView(entry: entry)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                }
                
                startWritingButton
                
                Spacer()
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
            .vibrantLinearBackground()
            .toolbarColorScheme(.dark, for: .navigationBar)
            
        }
    }

    private var startWritingButton: some View {
        Button {
            selectedTab = 2
        } label: {
            HStack(spacing: 8) {
                Text("let's start ")
                Text("write one")
                    .underline()
                Text("today")
            }
            .font(.system(size: 30))
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .modelContainer(for: DiaryModel.self, inMemory: true)
}
