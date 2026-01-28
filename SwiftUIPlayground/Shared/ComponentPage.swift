import SwiftUI

struct ComponentPage<Preview: View, Controls: View>: View {
    let title: String
    let description: String
    let code: String
    @ViewBuilder let preview: () -> Preview
    @ViewBuilder let controls: () -> Controls

    @State private var selectedTab = 0

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

                controls()
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        ComponentPage(
            title: "Button",
            description: "A control that initiates an action.",
            code: "Button(\"Tap me\") {\n    print(\"Tapped\")\n}"
        ) {
            Button("Tap me") {}
        } controls: {
            Text("Controls go here")
        }
    }
}
