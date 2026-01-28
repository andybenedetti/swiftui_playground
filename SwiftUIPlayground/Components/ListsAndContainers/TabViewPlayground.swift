import SwiftUI

struct TabViewPlayground: View {
    @State private var selectedTab = 0
    @State private var tabCount = 3
    @State private var tabStyle = TabStyleOption.automatic
    @State private var showBadge = false

    enum TabStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case page = "Page"
        case pageAlwaysVisible = "Page (Always Visible)"
    }

    private let tabIcons = ["house.fill", "magnifyingglass", "heart.fill", "person.fill", "gear"]
    private let tabLabels = ["Home", "Search", "Favorites", "Profile", "Settings"]
    private let tabColors: [Color] = [.blue, .green, .pink, .orange, .purple]

    var body: some View {
        ComponentPage(
            title: "TabView",
            description: "A view that switches between multiple child views using interactive tabs.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        tabViewContent
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var tabViewContent: some View {
        let tabView = TabView(selection: $selectedTab) {
            ForEach(0..<tabCount, id: \.self) { index in
                tabContent(for: index)
                    .tabItem {
                        Label(tabLabels[index], systemImage: tabIcons[index])
                    }
                    .tag(index)
                    .badge(showBadge && index == 1 ? 3 : 0)
            }
        }

        switch tabStyle {
        case .automatic:
            tabView
        case .page:
            tabView.tabViewStyle(.page)
        case .pageAlwaysVisible:
            tabView.tabViewStyle(.page(indexDisplayMode: .always))
        }
    }

    private func tabContent(for index: Int) -> some View {
        VStack {
            Image(systemName: tabIcons[index])
                .font(.largeTitle)
                .foregroundStyle(tabColors[index])
            Text(tabLabels[index])
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(tabColors[index].opacity(0.1))
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $tabStyle,
                options: TabStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Tabs",
                value: Binding(get: { Double(tabCount) }, set: { tabCount = Int($0) }),
                range: 2...5,
                step: 1,
                format: "%.0f"
            )

            if tabStyle == .automatic {
                ToggleControl(label: "Show Badge on Search", isOn: $showBadge)
            }
        }
    }

    private var generatedCode: String {
        var code = """
        // TabView with \(tabCount) tabs
        @State private var selectedTab = 0

        TabView(selection: $selectedTab) {
        """

        for i in 0..<tabCount {
            code += """

            \(tabLabels[i])View()
                .tabItem {
                    Label("\(tabLabels[i])", systemImage: "\(tabIcons[i])")
                }
                .tag(\(i))
        """
            if showBadge && i == 1 {
                code += "\n        .badge(3)"
            }
        }

        code += "\n}"

        switch tabStyle {
        case .automatic:
            break
        case .page:
            code += "\n.tabViewStyle(.page)"
        case .pageAlwaysVisible:
            code += "\n.tabViewStyle(.page(indexDisplayMode: .always))"
        }

        return code
    }
}

#Preview {
    NavigationStack {
        TabViewPlayground()
    }
}
