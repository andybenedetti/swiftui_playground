import SwiftUI

struct NavigationPathPlayground: View {
    @State private var path: [Int] = []
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
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/navigationpath")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 12) {
            // Stack depth indicator
            HStack {
                Text("Stack depth: \(path.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if path.count > 0 {
                    Button("Pop to Root") {
                        path.removeLast(path.count)
                    }
                    .font(.caption)
                }
            }

            // Visual stack representation
            VStack(spacing: 0) {
                // Simulated nav bar
                HStack {
                    if path.count > 0 {
                        Button {
                            path.removeLast()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.body.weight(.semibold))
                        }
                    }
                    Spacer()
                    Text(path.count == 0 ? "Home" : "Level \(path.count)")
                        .font(.headline)
                    Spacer()
                    if path.count > 0 {
                        // Balance the back button
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                            .hidden()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.bar)

                // Content area
                VStack(spacing: 16) {
                    Spacer()
                    Text(path.count == 0 ? "Root View" : "View \(path.count)")
                        .font(.title2.bold())

                    if path.count < 5 {
                        Button("Push View \(path.count + 1)") {
                            path.append(path.count + 1)
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    if path.count > 0 {
                        Button("Pop to Root") {
                            path.removeLast(path.count)
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button("Deep Link to View 3") {
                            path.append(1)
                            path.append(2)
                            path.append(3)
                        }
                        .buttonStyle(.bordered)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 260)
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Visual breadcrumb
            HStack(spacing: 4) {
                Text("Home")
                    .font(.caption2)
                    .foregroundStyle(path.count == 0 ? .primary : .secondary)
                ForEach(1...max(1, path.count), id: \.self) { i in
                    if i <= path.count {
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text("View \(i)")
                            .font(.caption2)
                            .foregroundStyle(i == path.count ? .primary : .secondary)
                    }
                }
            }
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
                        path.removeAll()
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
