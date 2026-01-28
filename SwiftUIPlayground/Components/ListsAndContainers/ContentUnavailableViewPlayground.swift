import SwiftUI

struct ContentUnavailableViewPlayground: View {
    @State private var viewType = ViewType.search
    @State private var customTitle = "No Results"
    @State private var customDescription = "Try a different search term."
    @State private var customSystemImage = "magnifyingglass"
    @State private var showAction = false
    @State private var actionLabel = "Retry"

    enum ViewType: String, CaseIterable {
        case search = "Search (Built-in)"
        case custom = "Custom"
        case noContent = "No Content"
        case error = "Error"
    }

    var body: some View {
        ComponentPage(
            title: "ContentUnavailableView",
            description: "A view displayed when content is unavailable. iOS 17+",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack {
            switch viewType {
            case .search:
                ContentUnavailableView.search

            case .custom:
                if showAction {
                    ContentUnavailableView {
                        Label(customTitle, systemImage: customSystemImage)
                    } description: {
                        Text(customDescription)
                    } actions: {
                        Button(actionLabel) {
                            // Action
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ContentUnavailableView {
                        Label(customTitle, systemImage: customSystemImage)
                    } description: {
                        Text(customDescription)
                    }
                }

            case .noContent:
                if showAction {
                    ContentUnavailableView {
                        Label("No Items", systemImage: "tray")
                    } description: {
                        Text("Items you add will appear here.")
                    } actions: {
                        Button("Add Item") {
                            // Action
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ContentUnavailableView {
                        Label("No Items", systemImage: "tray")
                    } description: {
                        Text("Items you add will appear here.")
                    }
                }

            case .error:
                if showAction {
                    ContentUnavailableView {
                        Label("Connection Error", systemImage: "wifi.slash")
                    } description: {
                        Text("Check your internet connection and try again.")
                    } actions: {
                        Button("Retry") {
                            // Action
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ContentUnavailableView {
                        Label("Connection Error", systemImage: "wifi.slash")
                    } description: {
                        Text("Check your internet connection and try again.")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Type",
                selection: $viewType,
                options: ViewType.allCases,
                optionLabel: { $0.rawValue }
            )

            if viewType == .custom {
                TextFieldControl(label: "Title", text: $customTitle)
                TextFieldControl(label: "Description", text: $customDescription)
                TextFieldControl(label: "SF Symbol", text: $customSystemImage)
            }

            if viewType != .search {
                ToggleControl(label: "Show Action Button", isOn: $showAction)

                if showAction && viewType == .custom {
                    TextFieldControl(label: "Button Label", text: $actionLabel)
                }
            }
        }
    }

    private var generatedCode: String {
        switch viewType {
        case .search:
            return """
            // Built-in search empty state
            ContentUnavailableView.search

            // Or with custom search text:
            // ContentUnavailableView.search(text: searchQuery)
            """

        case .custom:
            if showAction {
                return """
                // Custom unavailable view with action
                ContentUnavailableView {
                    Label("\(customTitle)", systemImage: "\(customSystemImage)")
                } description: {
                    Text("\(customDescription)")
                } actions: {
                    Button("\(actionLabel)") {
                        // Handle action
                    }
                    .buttonStyle(.borderedProminent)
                }
                """
            } else {
                return """
                // Custom unavailable view
                ContentUnavailableView {
                    Label("\(customTitle)", systemImage: "\(customSystemImage)")
                } description: {
                    Text("\(customDescription)")
                }
                """
            }

        case .noContent:
            if showAction {
                return """
                // Empty state with add action
                ContentUnavailableView {
                    Label("No Items", systemImage: "tray")
                } description: {
                    Text("Items you add will appear here.")
                } actions: {
                    Button("Add Item") {
                        // Handle add
                    }
                    .buttonStyle(.borderedProminent)
                }
                """
            } else {
                return """
                // Simple empty state
                ContentUnavailableView {
                    Label("No Items", systemImage: "tray")
                } description: {
                    Text("Items you add will appear here.")
                }
                """
            }

        case .error:
            if showAction {
                return """
                // Error state with retry
                ContentUnavailableView {
                    Label("Connection Error", systemImage: "wifi.slash")
                } description: {
                    Text("Check your internet connection and try again.")
                } actions: {
                    Button("Retry") {
                        // Handle retry
                    }
                    .buttonStyle(.borderedProminent)
                }
                """
            } else {
                return """
                // Error state
                ContentUnavailableView {
                    Label("Connection Error", systemImage: "wifi.slash")
                } description: {
                    Text("Check your internet connection and try again.")
                }
                """
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentUnavailableViewPlayground()
    }
}
