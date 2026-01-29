import SwiftUI

struct AccessibilityHintPlayground: View {
    // MARK: - State
    @State private var hintText = "Double tap to toggle favorite status"
    @State private var showHint = true
    @State private var isFavorite = false

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "accessibilityHint",
            description: "Provides additional context about what happens when the user interacts with a view.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/accessibilityhint(_:)-3i1ux")!,
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
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("Favorite Button")
                    .font(.headline)

                Button {
                    isFavorite.toggle()
                } label: {
                    Label(
                        isFavorite ? "Favorited" : "Add to Favorites",
                        systemImage: isFavorite ? "heart.fill" : "heart"
                    )
                    .font(.title2)
                    .foregroundStyle(isFavorite ? .red : .gray)
                }
                .accessibilityLabel(isFavorite ? "Favorited" : "Not favorited")
                .accessibilityHint(showHint ? hintText : "")
            }

            VStack(spacing: 8) {
                Text("Delete Button with Hint")
                    .font(.headline)

                Button(role: .destructive) {
                    // action
                } label: {
                    Label("Delete", systemImage: "trash")
                        .font(.title2)
                }
                .accessibilityHint(showHint ? "Double tap to permanently delete this item" : "")
            }

            VStack(spacing: 8) {
                Text("VoiceOver announces:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Label: \"\(isFavorite ? "Favorited" : "Not favorited")\"")
                    if showHint {
                        Text("Hint: \"\(hintText)\"")
                    }
                }
                .font(.caption.monospaced())
                .foregroundStyle(.blue)
            }
            .padding()
            .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Hint", isOn: $showHint)

            if showHint {
                TextFieldControl(label: "Hint Text", text: $hintText)
            }

            Text("Hints describe the result of an action, not the action itself. VoiceOver reads them after a brief pause.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        if showHint {
            return """
            Button {
                isFavorite.toggle()
            } label: {
                Label("Favorite", systemImage: "heart")
            }
            .accessibilityLabel("Not favorited")
            .accessibilityHint("\(hintText)")
            """
        } else {
            return """
            Button {
                isFavorite.toggle()
            } label: {
                Label("Favorite", systemImage: "heart")
            }
            .accessibilityLabel("Not favorited")
            // No hint — VoiceOver only reads the label
            """
        }
    }
}

#Preview {
    NavigationStack {
        AccessibilityHintPlayground()
    }
}
