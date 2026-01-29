import SwiftUI

struct ScrollViewReaderPlayground: View {
    // MARK: - State
    @State private var scrollTarget: Int = 0
    @State private var itemCount: Double = 50
    @State private var useAnimation = true
    @State private var anchorPosition: AnchorOption = .top

    enum AnchorOption: String, CaseIterable {
        case top = "Top"
        case center = "Center"
        case bottom = "Bottom"

        var anchor: UnitPoint {
            switch self {
            case .top: .top
            case .center: .center
            case .bottom: .bottom
            }
        }

        var codeName: String {
            switch self {
            case .top: ".top"
            case .center: ".center"
            case .bottom: ".bottom"
            }
        }
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "ScrollViewReader",
            description: "A view that provides programmatic scrolling to child views by their identifier.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/scrollviewreader")!,
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
        VStack(spacing: 12) {
            HStack {
                Button("First") {
                    scrollTarget = 0
                }
                .buttonStyle(.bordered)

                Button("Middle") {
                    scrollTarget = Int(itemCount) / 2
                }
                .buttonStyle(.bordered)

                Button("Last") {
                    scrollTarget = Int(itemCount) - 1
                }
                .buttonStyle(.bordered)
            }

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(0..<Int(itemCount), id: \.self) { index in
                            HStack {
                                Text("Item \(index)")
                                    .font(.body)
                                Spacer()
                                if index == scrollTarget {
                                    Image(systemName: "arrow.left")
                                        .foregroundStyle(.blue)
                                    Text("Target")
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                }
                            }
                            .padding()
                            .background(
                                index == scrollTarget
                                    ? Color.blue.opacity(0.15)
                                    : Color.secondary.opacity(0.05),
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                            .id(index)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 300)
                .onChange(of: scrollTarget) { _, target in
                    if useAnimation {
                        withAnimation {
                            proxy.scrollTo(target, anchor: anchorPosition.anchor)
                        }
                    } else {
                        proxy.scrollTo(target, anchor: anchorPosition.anchor)
                    }
                }
            }
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Scroll To",
                value: Binding(get: { Double(scrollTarget) }, set: { scrollTarget = Int($0) }),
                range: 0...Double(max(Int(itemCount) - 1, 1)),
                format: "%.0f"
            )

            SliderControl(label: "Item Count", value: $itemCount, range: 10...100, format: "%.0f")

            PickerControl(
                label: "Anchor",
                selection: $anchorPosition,
                options: AnchorOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Animate", isOn: $useAnimation)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        let animationWrap = useAnimation ? "withAnimation {\n            " : ""
        let animationClose = useAnimation ? "\n        }" : ""

        return """
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(0..<\(Int(itemCount)), id: \\.self) { index in
                    Text("Item \\(index)")
                        .id(index)
                }
            }

            Button("Scroll to Item") {
                \(animationWrap)proxy.scrollTo(\(scrollTarget), anchor: \(anchorPosition.codeName))\(animationClose)
            }
        }
        """
    }
}

#Preview {
    NavigationStack {
        ScrollViewReaderPlayground()
    }
}
