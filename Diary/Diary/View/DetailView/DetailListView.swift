//
//  DetailView.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 14/09/26.
//

import SwiftUI
import SwiftData

struct DetailListView: View {
    let entry: DiaryModel
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var selectedPhoto: PhotoItem?
    @State private var showDeleteAlert = false
    
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(entry.date, format: .dateTime.weekday(.wide).day().month(.wide).year())
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.top,100)
                    
                    Text(entry.title)
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if !entry.photoFileNames.isEmpty {
                    photoGallery
                }
                
                Text(entry.detail.isEmpty ? "No details" : entry.detail)
                    .font(.body)
                    .foregroundStyle(entry.detail.isEmpty ? .white.opacity(0.5) : .white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(16)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.white.opacity(0.6), lineWidth: 1.5)
                    }
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
        .vibrantLinearBackground()
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 90)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.white)
            }
        }
        .alert("Delete this diary?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { deletelist() }
        } message: {
            Text("Diary and photos will be deleted permanently.")
        }
        .fullScreenCover(item: $selectedPhoto) { item in
            PhotoViewer(fileName: item.fileName)
        }
    }
    
    private var photoGallery: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(entry.photoFileNames, id: \.self) { name in
                    if let ui = PhotoStore.thumbnail(name, maxPixel: 600) {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onTapGesture { selectedPhoto = PhotoItem(fileName: name) }
                    }
                }
            }
            .padding(.vertical, 2)
        }
        .scrollClipDisabled()
    }
}
