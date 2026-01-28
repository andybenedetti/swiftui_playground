import SwiftUI
import PhotosUI
import UIKit

struct PhotosPickerPlayground: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImage: Image?
    @State private var selectionMode = SelectionMode.single
    @State private var filterType = FilterType.images
    @State private var maxSelection = 4

    enum SelectionMode: String, CaseIterable {
        case single = "Single"
        case multiple = "Multiple"
    }

    enum FilterType: String, CaseIterable {
        case images = "Images"
        case videos = "Videos"
        case all = "All"

        var filter: PHPickerFilter {
            switch self {
            case .images: .images
            case .videos: .videos
            case .all: .any(of: [.images, .videos])
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "PhotosPicker",
            description: "Select photos and videos from the photo library.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/photokit/photospicker")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 16) {
            // Display area
            Group {
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.secondary.opacity(0.2))
                        .overlay {
                            VStack(spacing: 8) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                Text("No photo selected")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                }
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Picker button
            if selectionMode == .single {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: filterType.filter
                ) {
                    Label("Select Photo", systemImage: "photo.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                .onChange(of: selectedItem) { _, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }
                }
            } else {
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: maxSelection,
                    matching: filterType.filter
                ) {
                    Label("Select Photos (\(selectedItems.count))", systemImage: "photo.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                .onChange(of: selectedItems) { _, newValue in
                    Task {
                        if let first = newValue.first,
                           let data = try? await first.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }

            if selectionMode == .multiple && !selectedItems.isEmpty {
                Text("\(selectedItems.count) photo(s) selected")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 280)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Selection",
                selection: $selectionMode,
                options: SelectionMode.allCases,
                optionLabel: { $0.rawValue }
            )

            PickerControl(
                label: "Filter",
                selection: $filterType,
                options: FilterType.allCases,
                optionLabel: { $0.rawValue }
            )

            if selectionMode == .multiple {
                SliderControl(
                    label: "Max Selection",
                    value: Binding(
                        get: { Double(maxSelection) },
                        set: { maxSelection = Int($0) }
                    ),
                    range: 2...10,
                    format: "%.0f"
                )
            }
        }
    }

    private var generatedCode: String {
        if selectionMode == .single {
            return """
            import PhotosUI

            struct PhotoSelector: View {
                @State private var selectedItem: PhotosPickerItem?
                @State private var selectedImage: Image?

                var body: some View {
                    VStack {
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFit()
                        }

                        PhotosPicker(
                            selection: $selectedItem,
                            matching: \(filterType == .images ? ".images" : filterType == .videos ? ".videos" : ".any(of: [.images, .videos])")
                        ) {
                            Label("Select Photo", systemImage: "photo.badge.plus")
                        }
                        .onChange(of: selectedItem) { _, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                    }
                }
            }
            """
        } else {
            return """
            import PhotosUI

            struct PhotoSelector: View {
                @State private var selectedItems: [PhotosPickerItem] = []

                var body: some View {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: \(maxSelection),
                        matching: \(filterType == .images ? ".images" : filterType == .videos ? ".videos" : ".any(of: [.images, .videos])")
                    ) {
                        Label("Select Photos", systemImage: "photo.badge.plus")
                    }
                    .onChange(of: selectedItems) { _, items in
                        for item in items {
                            Task {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    // Process each selected image
                                }
                            }
                        }
                    }
                }
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        PhotosPickerPlayground()
    }
}
