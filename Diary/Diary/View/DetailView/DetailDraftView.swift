//
//  DetailDraftView.swift
//  Diary
//

import SwiftUI
import SwiftData
import PhotosUI

struct DetailDraftView: View {
    @Bindable var entry: DraftModel
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var selectedPhoto: PhotoItem?
    @State private var showDeleteAlert = false
    @State var showBackConfirm = false

    @State var pickerItems: [PhotosPickerItem] = []
    @State var isLoadingPhotos = false

    @State var originalTitle: String = ""
    @State var originalDate: Date = Date()
    @State var originalDetail: String = ""
    @State var originalPhotoFileNames: [String] = []
    @State var addedPhotoFileNames: Set<String> = []
    @State var pendingRemovedPhotoFileNames: Set<String> = []

    var hasUnsavedChanges: Bool {
        entry.title != originalTitle ||
        entry.date != originalDate ||
        entry.detail != originalDetail ||
        entry.photoFileNames != originalPhotoFileNames
    }

    private enum Field: Hashable {
        case title
        case detail
    }

    @FocusState private var focusedField: Field?

    private var canPublish: Bool {
        !entry.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        TextField("", text: $entry.title,
                                  prompt: Text("Title").foregroundStyle(.white.opacity(0.6)))
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                        .textFieldStyle(.underlineStyle)
                        .padding(.top,100)
                        .focused($focusedField, equals: .title)

                        DatePicker("", selection: $entry.date, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .tint(.yellow)
                            .environment(\.colorScheme, .dark)



                        photoSection

                        TextField("", text: $entry.detail,
                                  prompt: Text("Tell me how's your day.....")
                            .foregroundStyle(.white.opacity(0.75)),
                                  axis: .vertical)
                        .lineLimit(6...12)
                        .foregroundStyle(.white)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.white.opacity(0.6), lineWidth: 1.5)
                        }
                        .focused($focusedField, equals: .detail)
                        .id(Field.detail)

                        Button("SAVE DIARY") {
                            publish()
                        }
                        .buttonStyle(.tealOval)
                        .disabled(!canPublish || isLoadingPhotos)
                        .frame(maxWidth: .infinity)

                        if !canPublish {
                            Text("Add a title to save as diary")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(20)
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: focusedField) { _, newValue in
                    if newValue == .detail {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(Field.detail, anchor: .top)
                        }
                    }
                }
            }
        }
        .padding(.bottom, focusedField == nil ? 20 : 20)
        .vibrantLinearBackground()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    confirmBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .tint(.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.white)
            }
        }
        .alert("Delete this draft?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { deletedraft() }
        } message: {
            Text("Draft and photos will be deleted permanently.")
        }
        .alert("Do you want to save your last change of your draft?", isPresented: $showBackConfirm) {
            Button("No") { discardChangesAndDismiss() }
            Button("Yes") { saveChangesAndDismiss() }
        }
        .fullScreenCover(item: $selectedPhoto) { item in
            PhotoViewer(fileName: item.fileName)
        }
        .onAppear {
            originalTitle = entry.title
            originalDate = entry.date
            originalDetail = entry.detail
            originalPhotoFileNames = entry.photoFileNames
        }
    }
    
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PhotosPicker(selection: $pickerItems,
                         maxSelectionCount: 5,
                         matching: .images,
                         photoLibrary: .shared()) {
                ZStack {
                    Circle().strokeBorder(.white, lineWidth: 2)
                    if isLoadingPhotos {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "photo.badge.plus.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 50, height: 50)
            }
                         .disabled(isLoadingPhotos)
            
            if !entry.photoFileNames.isEmpty {
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
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            deletePhoto(name)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.white, .black.opacity(0.6))
                                                .font(.title3)
                                        }
                                        .padding(6)
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }
                .scrollClipDisabled()
            }
        }
        .onChange(of: pickerItems) { _, newItems in
            guard !newItems.isEmpty else { return }
            Task { await loadPhotos(newItems) }
        }
    }
    
}

