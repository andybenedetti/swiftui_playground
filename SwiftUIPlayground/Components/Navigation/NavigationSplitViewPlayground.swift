import SwiftUI

struct NavigationSplitViewPlayground: View {
    @State private var columnCount = ColumnCount.two
    @State private var selectedItem: String? = "Inbox"
    @State private var selectedDetail: String?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    enum ColumnCount: String, CaseIterable {
        case two = "Two Columns"
        case three = "Three Columns"
    }

    private let sidebarItems = ["Inbox", "Sent", "Drafts", "Trash"]
    private let contentItems = ["Message 1", "Message 2", "Message 3"]

    var body: some View {
        ComponentPage(
            title: "NavigationSplitView",
            description: "Creates a multi-column navigation layout (iPad).",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/navigationsplitview")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 8) {
            Text("Best viewed on iPad or landscape")
                .font(.caption)
                .foregroundStyle(.secondary)

            Group {
                switch columnCount {
                case .two:
                    twoColumnView
                case .three:
                    threeColumnView
                }
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder
    private var twoColumnView: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(sidebarItems, id: \.self, selection: $selectedItem) { item in
                Label(item, systemImage: iconFor(item))
            }
            .navigationTitle("Mail")
        } detail: {
            if let selected = selectedItem {
                Text("Content for \(selected)")
                    .navigationTitle(selected)
            } else {
                ContentUnavailableView("Select an Item", systemImage: "tray")
            }
        }
    }

    @ViewBuilder
    private var threeColumnView: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(sidebarItems, id: \.self, selection: $selectedItem) { item in
                Label(item, systemImage: iconFor(item))
            }
            .navigationTitle("Mail")
        } content: {
            if selectedItem != nil {
                List(contentItems, id: \.self, selection: $selectedDetail) { item in
                    Text(item)
                }
                .navigationTitle("Messages")
            } else {
                ContentUnavailableView("Select a Folder", systemImage: "folder")
            }
        } detail: {
            if let detail = selectedDetail {
                Text("Detail: \(detail)")
                    .navigationTitle(detail)
            } else {
                ContentUnavailableView("Select a Message", systemImage: "envelope")
            }
        }
    }

    private func iconFor(_ item: String) -> String {
        switch item {
        case "Inbox": "tray"
        case "Sent": "paperplane"
        case "Drafts": "doc"
        case "Trash": "trash"
        default: "folder"
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Columns",
                selection: $columnCount,
                options: ColumnCount.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        switch columnCount {
        case .two:
            return """
            // Two-column NavigationSplitView
            @State private var selected: String?

            NavigationSplitView {
                List(items, id: \\.self, selection: $selected) { item in
                    Label(item.name, systemImage: item.icon)
                }
                .navigationTitle("Sidebar")
            } detail: {
                if let selected {
                    DetailView(item: selected)
                } else {
                    ContentUnavailableView("Select an Item",
                        systemImage: "tray")
                }
            }
            """
        case .three:
            return """
            // Three-column NavigationSplitView
            @State private var selectedFolder: String?
            @State private var selectedItem: String?

            NavigationSplitView {
                // Sidebar
                List(folders, selection: $selectedFolder) { folder in
                    Label(folder.name, systemImage: folder.icon)
                }
            } content: {
                // Content list
                if let folder = selectedFolder {
                    List(folder.items, selection: $selectedItem) { item in
                        Text(item.name)
                    }
                }
            } detail: {
                // Detail view
                if let item = selectedItem {
                    DetailView(item: item)
                }
            }
            """
        }
    }
}

#Preview {
    NavigationSplitViewPlayground()
}
