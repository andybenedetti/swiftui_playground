import SwiftUI

struct ForEachPlayground: View {
    // MARK: - State
    @State private var selectedExample: ForEachExample = .identifiable
    @State private var itemCount: Double = 5
    @State private var showIndex = false

    enum ForEachExample: String, CaseIterable {
        case identifiable = "Identifiable"
        case range = "Range"
        case enumerated = "Enumerated"
        case keyPath = "KeyPath ID"
    }

    struct Fruit: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let color: Color
    }

    private var fruits: [Fruit] {
        let all = [
            Fruit(name: "Apple", emoji: "🍎", color: .red),
            Fruit(name: "Banana", emoji: "🍌", color: .yellow),
            Fruit(name: "Blueberry", emoji: "🫐", color: .blue),
            Fruit(name: "Cherry", emoji: "🍒", color: .pink),
            Fruit(name: "Grape", emoji: "🍇", color: .purple),
            Fruit(name: "Kiwi", emoji: "🥝", color: .green),
            Fruit(name: "Lemon", emoji: "🍋", color: .yellow),
            Fruit(name: "Mango", emoji: "🥭", color: .orange),
        ]
        return Array(all.prefix(Int(itemCount)))
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "ForEach",
            description: "A structure that computes views on demand from a collection of identified data.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/foreach")!,
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
        VStack(spacing: 0) {
            switch selectedExample {
            case .identifiable:
                ForEach(fruits) { fruit in
                    HStack {
                        Text(fruit.emoji)
                            .font(.title2)
                        Text(fruit.name)
                        Spacer()
                        Circle()
                            .fill(fruit.color)
                            .frame(width: 12, height: 12)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    Divider()
                }

            case .range:
                ForEach(0..<Int(itemCount), id: \.self) { index in
                    HStack {
                        Text("Item \(index + 1)")
                        Spacer()
                        if showIndex {
                            Text("index: \(index)")
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    Divider()
                }

            case .enumerated:
                ForEach(Array(fruits.enumerated()), id: \.offset) { index, fruit in
                    HStack {
                        Text("\(index).")
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                            .frame(width: 24)
                        Text(fruit.emoji)
                        Text(fruit.name)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    Divider()
                }

            case .keyPath:
                ForEach(["Swift", "Kotlin", "Rust", "Go", "Python"].prefix(Int(itemCount)), id: \.self) { language in
                    HStack {
                        Text(language)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    Divider()
                }
            }
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Example",
                selection: $selectedExample,
                options: ForEachExample.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(label: "Item Count", value: $itemCount, range: 1...8, format: "%.0f")

            if selectedExample == .range {
                ToggleControl(label: "Show Index", isOn: $showIndex)
            }

            Text("ForEach requires each element to be identifiable — either by conforming to Identifiable or providing an id: key path.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        switch selectedExample {
        case .identifiable:
            return """
            // Identifiable conformance
            struct Fruit: Identifiable {
                let id = UUID()
                let name: String
                let emoji: String
            }

            ForEach(fruits) { fruit in
                HStack {
                    Text(fruit.emoji)
                    Text(fruit.name)
                }
            }
            """
        case .range:
            return """
            // Range-based ForEach
            ForEach(0..<\(Int(itemCount)), id: \\.self) { index in
                Text("Item \\(index + 1)")
            }
            """
        case .enumerated:
            return """
            // Enumerated with index
            ForEach(Array(fruits.enumerated()), id: \\.offset) { index, fruit in
                HStack {
                    Text("\\(index). \\(fruit.name)")
                }
            }
            """
        case .keyPath:
            return """
            // KeyPath as identifier
            let languages = ["Swift", "Kotlin", "Rust"]

            ForEach(languages, id: \\.self) { language in
                Text(language)
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        ForEachPlayground()
    }
}
