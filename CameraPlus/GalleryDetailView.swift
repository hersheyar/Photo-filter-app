//
//  GalleryDetailView.swift
//  CameraPlus
//
//  Created by Andrew Hershey on 11/8/25.
//

import SwiftUI
import CoreData

struct GalleryDetailView: View {
    @Environment(\.managedObjectContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    let photo: EditedPhoto

    var body: some View {
        VStack(spacing: 16) {
            if let img = UIImage(data: photo.imageData ?? Data()) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .padding()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Filter: \(photo.filter ?? "Unknown")")
                Text(String(format: "Intensity: %.2f", photo.intensity))
                if let date = photo.createdAt {
                    Text("Saved: \(date.formatted(date: .abbreviated, time: .shortened))")
                }
            }
            .font(.subheadline)
            .padding()

            Button(role: .destructive) {
                ctx.delete(photo)
                try? ctx.save()
                dismiss()
            } label: {
                Label("Delete Photo", systemImage: "trash")
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Details")
    }
}
