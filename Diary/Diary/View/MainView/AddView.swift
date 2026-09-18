//
//  AddView.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 10/09/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddView: View {
    @Binding var selectedTab: Int

    @State var title: String = ""
    @State var date = Date()
    @State var detail: String = ""

    @State var pickerItems: [PhotosPickerItem] = []
    @State var imageData: [PickedImage] = []
    @State private var isLoadingPhotos = false

    @Environment(\.modelContext) var modelContext
    @AppStorage("loggedInUserId") var loggedInUserId: String = ""

    private enum Field: Hashable {
        case title
        case detail
    }

    @FocusState private var focusedField: Field?

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {

            VStack(alignment: .leading, spacing: 0) {

                Text("Add")
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding(.top, 42)
                    .padding(.bottom, 20)

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 28) {

                            TextField(
                                "",
                                text: $title,
                                prompt: Text("Title")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.body)
                            )
                            .textFieldStyle(.underlineStyle)
                            .focused($focusedField, equals: .title)

                            DatePicker("", selection: $date, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .tint(.yellow)
                                .environment(\.colorScheme, .dark)

                            TextField("", text: $detail, prompt: Text("Tell me how's your day.....")
                                .foregroundStyle(.white.opacity(0.75)), axis: .vertical)
                                .lineLimit(6...12)
                                .foregroundStyle(.white)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(.white, lineWidth: 1.5)
                                }
                                .focused($focusedField, equals: .detail)
                                .id(Field.detail)

                            photoSection

                            Button("SAVE DIARY") {
                                savediary()
                            }
                            .buttonStyle(.tealOval)
                            .disabled(!canSave || isLoadingPhotos)
                            .frame(maxWidth: .infinity)

                            Button("SAVE DRAFT") {
                                savedraft()
                            }
                            .buttonStyle(.orangeOval)
                            .disabled(!canSave || isLoadingPhotos)
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                    }
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
            .padding(.bottom, focusedField == nil ? 80 : 20)
            .vibrantLinearBackground()
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .tint(.white)
                }
            }
        }
    }


    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            PhotosPicker(selection: $pickerItems,
                         maxSelectionCount: 5,
                         matching: .images,
                         photoLibrary: .shared()) {
                ZStack {
                    Circle()
                        .strokeBorder(.white, lineWidth: 2)

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

            if !imageData.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(imageData) { item in
                            if let ui = UIImage(data: item.data) {
                                Image(uiImage: ui)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            imageData.removeAll { $0.id == item.id }
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.white, .black.opacity(0.6))
                                                .font(.title3)
                                        }
                                        .padding(4)
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .onChange(of: pickerItems) { _, newItems in
            guard !newItems.isEmpty else { return }
            Task { await loadPhotos(newItems) }
        }
    }

    @MainActor
    private func loadPhotos(_ items: [PhotosPickerItem]) async {
        isLoadingPhotos = true
        defer {
            isLoadingPhotos = false
            pickerItems = []
        }

        for item in items {
            guard let raw = try? await item.loadTransferable(type: Data.self),
                  let small = PhotoStore.downscale(raw) else { continue }
            imageData.append(PickedImage(data: small))
        }
    }
}

#Preview {
    AddView(selectedTab: .constant(2))
        .modelContainer(for: [DiaryModel.self, DraftModel.self], inMemory: true)
}
