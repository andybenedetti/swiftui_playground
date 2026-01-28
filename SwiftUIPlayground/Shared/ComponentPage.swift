import SwiftUI
import SafariServices

struct ComponentPage<Preview: View, Controls: View>: View {
    let title: String
    let description: String
    let documentationURL: URL?
    let code: String
    @ViewBuilder let preview: () -> Preview
    @ViewBuilder let controls: () -> Controls

    @State private var selectedTab = 0
    @State private var showingDocumentation = false

    init(
        title: String,
        description: String,
        documentationURL: URL? = nil,
        code: String,
        @ViewBuilder preview: @escaping () -> Preview,
        @ViewBuilder controls: @escaping () -> Controls
    ) {
        self.title = title
        self.description = description
        self.documentationURL = documentationURL
        self.code = code
        self.preview = preview
        self.controls = controls
    }

    var body: some View {
        VStack(spacing: 0) {
            // Live Preview Area
            previewSection

            Divider()

            // Bottom section with tabs
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    Text("Controls").tag(0)
                    Text("Code").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()

                if selectedTab == 0 {
                    controlsSection
                } else {
                    CodePreview(code: code)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingDocumentation) {
            if let url = documentationURL {
                SafariView(url: url)
            }
        }
    }

    private var previewSection: some View {
        VStack(spacing: 8) {
            Text("Preview")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            preview()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }

    private var controlsSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if documentationURL != nil {
                    Button {
                        showingDocumentation = true
                    } label: {
                        Label("View Documentation", systemImage: "book")
                            .font(.subheadline)
                    }
                }

                controls()
            }
            .padding()
        }
    }
}

// MARK: - Safari View
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        ComponentPage(
            title: "Button",
            description: "A control that initiates an action.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/button"),
            code: "Button(\"Tap me\") {\n    print(\"Tapped\")\n}"
        ) {
            Button("Tap me") {}
        } controls: {
            Text("Controls go here")
        }
    }
}
