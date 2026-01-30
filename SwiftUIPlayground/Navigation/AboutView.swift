import SwiftUI
import SafariServices

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var safariURL: URL?

    private var componentCount: Int {
        ComponentCategory.allCases.reduce(0) { $0 + $1.components.count }
    }

    private var categoryCount: Int {
        ComponentCategory.allCases.count
    }

    private var versionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    private static let repoBase = "https://github.com/andybenedetti/swiftui_playground"

    var body: some View {
        List {
            // App Identity
            Section {
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.indigo.gradient)
                            .frame(width: 80, height: 80)
                        Image(systemName: "swift")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.white)
                    }

                    Text("SwiftUI Play")
                        .font(.title2.bold())

                    Text(versionString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
            }

            // Stats
            Section("Stats") {
                StatRow(icon: "cube.fill", label: "Components", value: "\(componentCount)")
                StatRow(icon: "folder.fill", label: "Categories", value: "\(categoryCount)")
                StatRow(icon: "iphone", label: "Minimum iOS", value: "17.0")
            }

            // Links
            Section("Links") {
                AboutLink(label: "GitHub Repository", icon: "chevron.left.forwardslash.chevron.right", url: Self.repoBase) {
                    safariURL = $0
                }
                AboutLink(label: "Developer Journal", icon: "book", url: "\(Self.repoBase)/blob/main/BLOG.md") {
                    safariURL = $0
                }
                AboutLink(label: "Progress Tracker", icon: "chart.bar.fill", url: "\(Self.repoBase)/blob/main/PROGRESS.md") {
                    safariURL = $0
                }
                AboutLink(label: "Claude & Swift Development", icon: "cpu", url: "\(Self.repoBase)/blob/main/.claude/SWIFT_CLAUDE.md") {
                    safariURL = $0
                }
            }

            // Built With
            Section("Built With") {
                Label("SwiftUI", systemImage: "swift")
                Label("Claude by Anthropic", systemImage: "sparkles")
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .sheet(item: $safariURL) { url in
            SafariView(url: url)
                .ignoresSafeArea()
        }
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

private struct AboutLink: View {
    let label: String
    let icon: String
    let url: String
    let onTap: (URL) -> Void

    var body: some View {
        Button {
            if let url = URL(string: url) {
                onTap(url)
            }
        } label: {
            HStack {
                Label(label, systemImage: icon)
                Spacer()
                Image(systemName: "safari")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct StatRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}
