import SwiftUI

struct StatePlayground: View {
    @State private var counter = 0
    @State private var text = "Hello"
    @State private var isOn = false
    @State private var showMutation = true

    var body: some View {
        ComponentPage(
            title: "@State",
            description: "A property wrapper that stores value types and triggers view updates when changed. iOS 13+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/state")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 24) {
            // Counter example
            VStack(spacing: 12) {
                Text("Counter: \(counter)")
                    .font(.title)
                    .fontWeight(.bold)
                    .contentTransition(.numericText())

                HStack(spacing: 16) {
                    Button("−") { counter -= 1 }
                        .buttonStyle(.bordered)
                    Button("+") { counter += 1 }
                        .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Text example
            VStack(spacing: 12) {
                Text(text)
                    .font(.headline)

                TextField("Edit text", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 200)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Toggle example
            Toggle("Toggle State: \(isOn ? "ON" : "OFF")", isOn: $isOn)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
        .animation(.default, value: counter)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Mutation Examples", isOn: $showMutation)

            if showMutation {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Try the controls above!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("@State automatically triggers view updates when values change.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var generatedCode: String {
        """
        struct CounterView: View {
            @State private var counter = 0
            @State private var text = "Hello"
            @State private var isOn = false

            var body: some View {
                VStack {
                    // Reading state
                    Text("Count: \\(counter)")

                    // Mutating state
                    Button("+") { counter += 1 }

                    // Two-way binding with $
                    TextField("Edit", text: $text)
                    Toggle("Enabled", isOn: $isOn)
                }
            }
        }
        """
    }
}

#Preview {
    NavigationStack {
        StatePlayground()
    }
}
