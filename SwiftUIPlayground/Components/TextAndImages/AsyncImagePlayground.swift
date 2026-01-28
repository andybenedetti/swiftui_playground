import SwiftUI

struct AsyncImagePlayground: View {
    @State private var imageURL = "https://picsum.photos/200"
    @State private var showPlaceholder = true
    @State private var contentMode = ContentModeOption.fit
    @State private var cornerRadius: Double = 0
    @State private var frameSize: Double = 150

    enum ContentModeOption: String, CaseIterable {
        case fit = "Fit"
        case fill = "Fill"
    }

    var body: some View {
        ComponentPage(
            title: "AsyncImage",
            description: "A view that asynchronously loads and displays an image from a URL.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/asyncimage")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                if showPlaceholder {
                    ProgressView()
                        .frame(width: frameSize, height: frameSize)
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: frameSize, height: frameSize)
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode == .fit ? .fit : .fill)
                    .frame(width: frameSize, height: frameSize)
                    .clipped()
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .frame(width: frameSize, height: frameSize)
                    .background(Color.gray.opacity(0.2))
            @unknown default:
                EmptyView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Image URL", text: $imageURL)

            Button("Load Random Image") {
                imageURL = "https://picsum.photos/200?\(UUID().uuidString)"
            }
            .buttonStyle(.bordered)

            PickerControl(
                label: "Content Mode",
                selection: $contentMode,
                options: ContentModeOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(label: "Size", value: $frameSize, range: 50...250, format: "%.0f")
            SliderControl(label: "Corner Radius", value: $cornerRadius, range: 0...50, format: "%.0f")

            ToggleControl(label: "Show Loading Indicator", isOn: $showPlaceholder)
        }
    }

    private var generatedCode: String {
        var code = """
        // AsyncImage with phase handling
        AsyncImage(url: URL(string: "\(imageURL)")) { phase in
            switch phase {
            case .empty:
        """

        if showPlaceholder {
            code += """

                ProgressView()
        """
        } else {
            code += """

                Color.gray.opacity(0.3)
        """
        }

        code += """

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .\(contentMode.rawValue.lowercased()))
                    .frame(width: \(Int(frameSize)), height: \(Int(frameSize)))
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
        """

        if cornerRadius > 0 {
            code += "\n.clipShape(RoundedRectangle(cornerRadius: \(Int(cornerRadius))))"
        }

        return code
    }
}

#Preview {
    NavigationStack {
        AsyncImagePlayground()
    }
}
