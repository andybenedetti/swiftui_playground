import SwiftUI

struct ListPlayground: View {
    @State private var items = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    @State private var listStyle = ListStyleOption.automatic
    @State private var showSections = false
    @State private var showRowSeparators = true

    enum ListStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case plain = "Plain"
        case insetGrouped = "Inset Grouped"
        case grouped = "Grouped"
        case inset = "Inset"
    }

    var body: some View {
        ComponentPage(
            title: "List",
            description: "A container that presents rows of data in a single column.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        Group {
            if showSections {
                listWithSections
            } else {
                simpleList
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    private var simpleList: some View {
        let list = List {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
            .listRowSeparator(showRowSeparators ? .visible : .hidden)
        }

        switch listStyle {
        case .automatic:
            list
        case .plain:
            list.listStyle(.plain)
        case .insetGrouped:
            list.listStyle(.insetGrouped)
        case .grouped:
            list.listStyle(.grouped)
        case .inset:
            list.listStyle(.inset)
        }
    }

    @ViewBuilder
    private var listWithSections: some View {
        let list = List {
            Section("Fruits") {
                ForEach(items.prefix(3), id: \.self) { item in
                    Text(item)
                }
                .listRowSeparator(showRowSeparators ? .visible : .hidden)
            }

            Section("More Fruits") {
                ForEach(items.suffix(2), id: \.self) { item in
                    Text(item)
                }
                .listRowSeparator(showRowSeparators ? .visible : .hidden)
            }
        }

        switch listStyle {
        case .automatic:
            list
        case .plain:
            list.listStyle(.plain)
        case .insetGrouped:
            list.listStyle(.insetGrouped)
        case .grouped:
            list.listStyle(.grouped)
        case .inset:
            list.listStyle(.inset)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $listStyle,
                options: ListStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Show Sections", isOn: $showSections)
            ToggleControl(label: "Row Separators", isOn: $showRowSeparators)

            VStack(alignment: .leading, spacing: 8) {
                Text("Items")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(items.indices, id: \.self) { index in
                    HStack {
                        TextField("Item", text: $items[index])
                            .textFieldStyle(.roundedBorder)

                        if items.count > 2 {
                            Button(role: .destructive) {
                                items.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                            }
                        }
                    }
                }

                if items.count < 8 {
                    Button {
                        items.append("New Item")
                    } label: {
                        Label("Add Item", systemImage: "plus.circle.fill")
                    }
                }
            }
        }
    }

    private var generatedCode: String {
        var code = "// List view\n"

        if showSections {
            code += """
            List {
                Section("Fruits") {
                    ForEach(items, id: \\.self) { item in
                        Text(item)
                    }
                }
            }
            """
        } else {
            code += """
            List {
                ForEach(items, id: \\.self) { item in
                    Text(item)
                }
            }
            """
        }

        switch listStyle {
        case .automatic:
            break
        case .plain:
            code += "\n.listStyle(.plain)"
        case .insetGrouped:
            code += "\n.listStyle(.insetGrouped)"
        case .grouped:
            code += "\n.listStyle(.grouped)"
        case .inset:
            code += "\n.listStyle(.inset)"
        }

        if !showRowSeparators {
            code = code.replacingOccurrences(
                of: "Text(item)\n                    }",
                with: "Text(item)\n                    }\n                    .listRowSeparator(.hidden)"
            )
        }

        return code
    }
}

#Preview {
    NavigationStack {
        ListPlayground()
    }
}
