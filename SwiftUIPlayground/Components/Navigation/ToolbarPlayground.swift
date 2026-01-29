import SwiftUI

struct ToolbarPlayground: View {
    @State private var placement = PlacementOption.topBarTrailing
    @State private var itemType = ItemType.button
    @State private var showMultiple = false

    enum PlacementOption: String, CaseIterable {
        case topBarLeading = "Top Leading"
        case topBarTrailing = "Top Trailing"
        case bottomBar = "Bottom Bar"
        case principal = "Principal (Center)"
    }

    enum ItemType: String, CaseIterable {
        case button = "Button"
        case menu = "Menu"
        case editButton = "EditButton"
    }

    var body: some View {
        ComponentPage(
            title: "Toolbar",
            description: "Adds items to the navigation bar or bottom bar.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/toolbar(content:)-5w0tj")!,
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
            // Simulated navigation bar with toolbar items
            HStack {
                if placement == .topBarLeading {
                    toolbarContent
                } else if showMultiple && placement == .topBarTrailing {
                    Button(action: {}) {
                        Image(systemName: "sidebar.left")
                    }
                }

                Spacer()

                if placement == .principal {
                    toolbarContent
                } else {
                    Text("Toolbar Demo")
                        .font(.headline)
                }

                Spacer()

                if placement == .topBarTrailing {
                    toolbarContent
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(.bar)

            // Simulated list content
            List {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
            }
            .listStyle(.plain)

            // Simulated bottom bar
            if placement == .bottomBar {
                HStack {
                    Spacer()
                    toolbarContent
                    Spacer()
                }
                .padding(.vertical, 10)
                .background(.bar)
            }
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var toolbarPlacement: ToolbarItemPlacement {
        switch placement {
        case .topBarLeading: .topBarLeading
        case .topBarTrailing: .topBarTrailing
        case .bottomBar: .bottomBar
        case .principal: .principal
        }
    }

    @ViewBuilder
    private var toolbarContent: some View {
        switch itemType {
        case .button:
            Button(action: {}) {
                Image(systemName: "plus")
            }
        case .menu:
            Menu {
                Button("Option 1", action: {})
                Button("Option 2", action: {})
                Button("Option 3", action: {})
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        case .editButton:
            EditButton()
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Placement",
                selection: $placement,
                options: PlacementOption.allCases,
                optionLabel: { $0.rawValue }
            )

            PickerControl(
                label: "Item Type",
                selection: $itemType,
                options: ItemType.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Multiple Items", isOn: $showMultiple)
        }
    }

    private var generatedCode: String {
        let placementCode: String
        switch placement {
        case .topBarLeading: placementCode = ".topBarLeading"
        case .topBarTrailing: placementCode = ".topBarTrailing"
        case .bottomBar: placementCode = ".bottomBar"
        case .principal: placementCode = ".principal"
        }

        let itemCode: String
        switch itemType {
        case .button:
            itemCode = """
            Button(action: { }) {
                            Image(systemName: "plus")
                        }
            """
        case .menu:
            itemCode = """
            Menu {
                            Button("Option 1", action: { })
                            Button("Option 2", action: { })
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
            """
        case .editButton:
            itemCode = "EditButton()"
        }

        if showMultiple && placement == .topBarTrailing {
            return """
            // Multiple toolbar items
            .toolbar {
                ToolbarItem(placement: \(placementCode)) {
                    \(itemCode)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { }) {
                        Image(systemName: "sidebar.left")
                    }
                }
            }
            """
        }

        return """
        // Single toolbar item
        .toolbar {
            ToolbarItem(placement: \(placementCode)) {
                \(itemCode)
            }
        }
        """
    }
}

#Preview {
    ToolbarPlayground()
}
