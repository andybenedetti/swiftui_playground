import SwiftUI

struct NavigationPathPlayground: View {
    @State private var path = NavigationPath()
    @State private var navigationStyle = NavigationStyle.push
    @State private var showControls = true

    enum NavigationStyle: String, CaseIterable {
        case push = "Push Views"
        case popToRoot = "Pop to Root"
        case deepLink = "Deep Link"
    }

    var body: some View {
        ComponentPage(
            title: "NavigationPath",
            description: "Programmatically control navigation stack.",
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
            HStack {
                Text("Stack depth: \(path.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if path.count > 0 {
                    Button("Pop to Root") {
                        path = NavigationPath()
                    }
                    .font(.caption)
                }
            }
            .padding(.horizontal)

            NavigationStack(path: $path) {
                VStack(spacing: 20) {
                    Text("Root View")
                        .font(.headline)

                    Button("Push View 1") {
                        path.append(1)
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Deep Link to View 3") {
                        path.append(1)
                        path.append(2)
                        path.append(3)
                    }
                    .buttonStyle(.bordered)
                }
                .navigationTitle("Home")
                .navigationDestination(for: Int.self) { value in
                    VStack(spacing: 20) {
                        Text("View \(value)")
                            .font(.headline)

                        if value < 5 {
                            Button("Push View \(value + 1)") {
                                path.append(value + 1)
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        Button("Pop to Root") {
                            path = NavigationPath()
                        }
                        .buttonStyle(.bordered)
                    }
                    .navigationTitle("Level \(value)")
                }
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Demo",
                selection: $navigationStyle,
                options: NavigationStyle.allCases,
                optionLabel: { $0.rawValue }
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Actions")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack {
                    Button("Push") {
                        path.append(path.count + 1)
                    }
                    .buttonStyle(.bordered)

                    Button("Pop") {
                        if !path.isEmpty {
                            path.removeLast()
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(path.isEmpty)

                    Button("Reset") {
                        path = NavigationPath()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private var generatedCode: String {
        switch navigationStyle {
        case .push:
            return """
            // Programmatic navigation with NavigationPath
            @State private var path = NavigationPath()

            NavigationStack(path: $path) {
                Button("Go to Detail") {
                    path.append("detail")
                }
                .navigationDestination(for: String.self) { value in
                    DetailView(id: value)
                }
            }
            """
        case .popToRoot:
            return """
            // Pop to root by resetting path
            @State private var path = NavigationPath()

            NavigationStack(path: $path) {
                // ... views ...
                .navigationDestination(for: Int.self) { value in
                    VStack {
                        Text("View \\(value)")
                        Button("Pop to Root") {
                            path = NavigationPath()  // Clears stack
                        }
                    }
                }
            }
            """
        case .deepLink:
            return """
            // Deep link by appending multiple values
            @State private var path = NavigationPath()

            func handleDeepLink() {
                path.append("category")
                path.append("subcategory")
                path.append("item")
            }

            NavigationStack(path: $path) {
                // ... views ...
                .onOpenURL { url in
                    handleDeepLink()
                }
            }
            """
        }
    }
}

#Preview {
    NavigationPathPlayground()
}
