//
//  GalleryView.swift
//  CameraPlus
//
//  Created by Andrew Hershey on 11/8/25.
//

import SwiftUI
import CoreData

struct GalleryView: View {
    @Environment(\.managedObjectContext) private var ctx
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \EditedPhoto.createdAt, ascending: false)],
        animation: .default
    ) private var photos: FetchedResults<EditedPhoto>

    var body: some View {
        NavigationStack {
            Group {
                if photos.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No saved photos yet.")
                            .foregroundStyle(.secondary)
                        Button("Open Camera") {
                            
                        }
                            .buttonStyle(.borderedProminent)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                            ForEach(photos) { photo in
                                if let img = UIImage(data: photo.imageData ?? Data()) {
                                    NavigationLink {
                                        GalleryDetailView(photo: photo)
                                    } label: {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                            .onDelete(perform: delete)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Gallery")
        }
    }

    private func delete(offsets: IndexSet) {
        offsets.map { photos[$0] }.forEach(ctx.delete)
        try? ctx.save()
    }
}
