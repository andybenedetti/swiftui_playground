import SwiftUI

struct DynamicTypePlayground: View {
    // MARK: - State
    @State private var selectedSize: DynamicTypeSize = .large
    @State private var showAllSizes = false
    @State private var sampleText = "Hello, World!"

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "Dynamic Type",
            description: "Adapts text size based on the user's preferred content size setting for accessibility.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/dynamictypesize")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    // MARK: - Preview
    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 20) {
            if showAllSizes {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(allSizes, id: \.self) { size in
                            HStack {
                                Text(sizeName(size))
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                                    .frame(width: 120, alignment: .trailing)

                                Text(sampleText)
                                    .dynamicTypeSize(size)
                            }
                            if size != allSizes.last {
                                Divider()
                            }
                        }
                    }
                    .padding()
                }
            } else {
                VStack(spacing: 16) {
                    Text(sampleText)
                        .font(.body)
                        .dynamicTypeSize(selectedSize)

                    Text(sampleText)
                        .font(.headline)
                        .dynamicTypeSize(selectedSize)

                    Text(sampleText)
                        .font(.title)
                        .dynamicTypeSize(selectedSize)
                }
                .padding()

                Text("Current: \(sizeName(selectedSize))")
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                    .padding(8)
                    .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private var allSizes: [DynamicTypeSize] {
        [.xSmall, .small, .medium, .large, .xLarge, .xxLarge, .xxxLarge,
         .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5]
    }

    private func sizeName(_ size: DynamicTypeSize) -> String {
        switch size {
        case .xSmall: "xSmall"
        case .small: "small"
        case .medium: "medium"
        case .large: "large (default)"
        case .xLarge: "xLarge"
        case .xxLarge: "xxLarge"
        case .xxxLarge: "xxxLarge"
        case .accessibility1: "accessibility1"
        case .accessibility2: "accessibility2"
        case .accessibility3: "accessibility3"
        case .accessibility4: "accessibility4"
        case .accessibility5: "accessibility5"
        @unknown default: "unknown"
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show All Sizes", isOn: $showAllSizes)

            if !showAllSizes {
                PickerControl(
                    label: "Size",
                    selection: $selectedSize,
                    options: allSizes,
                    optionLabel: { sizeName($0) }
                )
            }

            TextFieldControl(label: "Sample Text", text: $sampleText)

            Text("Dynamic Type lets users choose their preferred text size. Use .dynamicTypeSize() to preview different sizes, or limit the range with .dynamicTypeSize(...DynamicTypeSize.xxxLarge).")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        if showAllSizes {
            return """
            // Preview all Dynamic Type sizes
            Text("\(sampleText)")
                .dynamicTypeSize(.xSmall...accessibility5)

            // Limit maximum size
            Text("\(sampleText)")
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            """
        } else {
            return """
            Text("\(sampleText)")
                .dynamicTypeSize(.\(sizeCodeName(selectedSize)))
            """
        }
    }

    private func sizeCodeName(_ size: DynamicTypeSize) -> String {
        switch size {
        case .xSmall: "xSmall"
        case .small: "small"
        case .medium: "medium"
        case .large: "large"
        case .xLarge: "xLarge"
        case .xxLarge: "xxLarge"
        case .xxxLarge: "xxxLarge"
        case .accessibility1: "accessibility1"
        case .accessibility2: "accessibility2"
        case .accessibility3: "accessibility3"
        case .accessibility4: "accessibility4"
        case .accessibility5: "accessibility5"
        @unknown default: "large"
        }
    }
}

#Preview {
    NavigationStack {
        DynamicTypePlayground()
    }
}
