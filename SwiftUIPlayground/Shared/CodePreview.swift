import SwiftUI

struct CodePreview: View {
    let code: String
    @AppStorage("includeComments") private var includeComments = true
    @State private var showCopied = false

    var body: some View {
        VStack(spacing: 0) {
            // Settings bar
            HStack {
                Toggle("Include comments", isOn: $includeComments)
                    .font(.caption)

                Spacer()

                Button {
                    copyCode()
                } label: {
                    Label(showCopied ? "Copied!" : "Copy", systemImage: showCopied ? "checkmark" : "doc.on.doc")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .tint(showCopied ? .green : .accentColor)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            Divider()

            // Code display
            ScrollView([.horizontal, .vertical]) {
                Text(displayCode)
                    .font(.system(.caption, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(Color(.secondarySystemBackground))
        }
    }

    private var displayCode: String {
        if includeComments {
            return code
        }
        return removeComments(from: code)
    }

    private func removeComments(from code: String) -> String {
        let lines = code.components(separatedBy: .newlines)
        let filtered = lines.filter { line in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            return !trimmed.hasPrefix("//")
        }
        return filtered.joined(separator: "\n")
    }

    private func copyCode() {
        UIPasteboard.general.string = displayCode
        withAnimation {
            showCopied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopied = false
            }
        }
    }
}

#Preview {
    CodePreview(code: """
        // Create a simple button
        Button("Tap me") {
            print("Button tapped!")
        }
        .buttonStyle(.borderedProminent)
        """)
}
