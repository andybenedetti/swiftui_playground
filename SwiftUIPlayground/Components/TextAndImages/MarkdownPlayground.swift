import SwiftUI

struct MarkdownPlayground: View {
    // MARK: - State
    @State private var selectedExample: MarkdownExample = .inline
    @State private var customMarkdown = "**Bold**, *italic*, and ~~strikethrough~~"

    enum MarkdownExample: String, CaseIterable {
        case inline = "Inline Styles"
        case links = "Links"
        case combined = "Combined"
        case custom = "Custom Text"
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "Markdown",
            description: "SwiftUI Text natively renders inline Markdown including bold, italic, strikethrough, code, and links.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/text/init(_:)-1a4oh")!,
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
        VStack(spacing: 24) {
            switch selectedExample {
            case .inline:
                VStack(alignment: .leading, spacing: 12) {
                    Text("**Bold text**")
                    Text("*Italic text*")
                    Text("~~Strikethrough~~")
                    Text("`Inline code`")
                    Text("**Bold** and *italic* together")
                    Text("***Bold italic***")
                }
                .font(.body)

            case .links:
                VStack(alignment: .leading, spacing: 12) {
                    Text("[Apple Developer](https://developer.apple.com)")
                    Text("Visit [SwiftUI docs](https://developer.apple.com/documentation/swiftui) for more.")
                    Text("Email [support](mailto:support@example.com)")
                }
                .font(.body)

            case .combined:
                VStack(alignment: .leading, spacing: 12) {
                    Text("Welcome to **SwiftUI**! This framework makes building *beautiful* apps ~~hard~~ easy.")
                    Text("Check the [documentation](https://developer.apple.com) for `View` protocol details.")
                    Text("Use `@State` for **local** state and `@Binding` for *passed* state.")
                }
                .font(.body)

            case .custom:
                Text(LocalizedStringKey(customMarkdown))
                    .font(.body)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Example",
                selection: $selectedExample,
                options: MarkdownExample.allCases,
                optionLabel: { $0.rawValue }
            )

            if selectedExample == .custom {
                TextFieldControl(label: "Markdown", text: $customMarkdown)
            }

            Text("Markdown in Text requires a string literal or LocalizedStringKey. String variables need explicit LocalizedStringKey conversion.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        switch selectedExample {
        case .inline:
            return """
            // Inline Markdown styles
            Text("**Bold text**")
            Text("*Italic text*")
            Text("~~Strikethrough~~")
            Text("`Inline code`")
            Text("***Bold italic***")
            """
        case .links:
            return """
            // Links in Markdown
            Text("[Apple Developer](https://developer.apple.com)")
            Text("Visit [SwiftUI docs](https://developer.apple.com/documentation/swiftui)")
            """
        case .combined:
            return """
            // Combined Markdown
            Text("Welcome to **SwiftUI**! Building *beautiful* apps.")
            Text("Check [docs](https://developer.apple.com) for `View` details.")
            """
        case .custom:
            return """
            // Dynamic Markdown from variable
            let markdown = "\(customMarkdown)"
            Text(LocalizedStringKey(markdown))
            """
        }
    }
}

#Preview {
    NavigationStack {
        MarkdownPlayground()
    }
}
