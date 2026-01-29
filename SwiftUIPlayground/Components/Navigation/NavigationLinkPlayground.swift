import SwiftUI

struct NavigationLinkPlayground: View {
    @State private var linkStyle = LinkStyle.label
    @State private var showChevron = true

    enum LinkStyle: String, CaseIterable {
        case label = "Text Label"
        case iconLabel = "Icon + Label"
        case custom = "Custom View"
    }

    var body: some View {
        ComponentPage(
            title: "NavigationLink",
            description: "Creates a navigation link to a destination view.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/navigationlink")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 0) {
            // Simulated navigation bar
            Text("Menu")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.bar)

            // Simulated list rows with disclosure indicators
            List {
                switch linkStyle {
                case .label:
                    navRow("Settings")
                    navRow("Profile")
                    navRow("Help")
                case .iconLabel:
                    navRow("Settings", icon: "gear")
                    navRow("Profile", icon: "person")
                    navRow("Help", icon: "questionmark.circle")
                case .custom:
                    HStack {
                        Image(systemName: "gear")
                            .foregroundStyle(.blue)
                            .frame(width: 30)
                        VStack(alignment: .leading) {
                            Text("Settings")
                                .font(.headline)
                            Text("App preferences")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .listStyle(.plain)
        }
        .frame(height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func navRow(_ title: String, icon: String? = nil) -> some View {
        HStack {
            if let icon {
                Label(title, systemImage: icon)
            } else {
                Text(title)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $linkStyle,
                options: LinkStyle.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        switch linkStyle {
        case .label:
            return """
            // Simple text NavigationLink
            NavigationStack {
                List {
                    NavigationLink("Settings", value: "settings")
                    NavigationLink("Profile", value: "profile")
                }
                .navigationDestination(for: String.self) { value in
                    DetailView(item: value)
                }
            }
            """
        case .iconLabel:
            return """
            // NavigationLink with Label
            NavigationStack {
                List {
                    NavigationLink(value: "settings") {
                        Label("Settings", systemImage: "gear")
                    }
                    NavigationLink(value: "profile") {
                        Label("Profile", systemImage: "person")
                    }
                }
                .navigationDestination(for: String.self) { value in
                    DetailView(item: value)
                }
            }
            """
        case .custom:
            return """
            // NavigationLink with custom content
            NavigationStack {
                List {
                    NavigationLink(value: "settings") {
                        HStack {
                            Image(systemName: "gear")
                            VStack(alignment: .leading) {
                                Text("Settings")
                                    .font(.headline)
                                Text("App preferences")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .navigationDestination(for: String.self) { value in
                    DetailView(item: value)
                }
            }
            """
        }
    }
}

#Preview {
    NavigationLinkPlayground()
}
