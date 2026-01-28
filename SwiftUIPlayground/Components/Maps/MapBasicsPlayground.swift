import SwiftUI
import MapKit

struct MapBasicsPlayground: View {
    @State private var mapStyle = MapStyleOption.standard
    @State private var showsTraffic = false
    @State private var elevation = ElevationOption.flat

    enum MapStyleOption: String, CaseIterable {
        case standard = "Standard"
        case imagery = "Imagery"
        case hybrid = "Hybrid"
    }

    enum ElevationOption: String, CaseIterable {
        case flat = "Flat"
        case realistic = "Realistic"
    }

    // San Francisco coordinates
    let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

    var body: some View {
        ComponentPage(
            title: "Map Basics",
            description: "Display maps with different styles using MapKit.",
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
            Map {
                // Empty map showing the region
            }
            .mapStyle(currentMapStyle)
            .frame(height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var currentMapStyle: MapStyle {
        switch mapStyle {
        case .standard:
            return .standard(elevation: elevation == .realistic ? .realistic : .flat, showsTraffic: showsTraffic)
        case .imagery:
            return .imagery(elevation: elevation == .realistic ? .realistic : .flat)
        case .hybrid:
            return .hybrid(elevation: elevation == .realistic ? .realistic : .flat, showsTraffic: showsTraffic)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $mapStyle,
                options: MapStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            PickerControl(
                label: "Elevation",
                selection: $elevation,
                options: ElevationOption.allCases,
                optionLabel: { $0.rawValue }
            )

            if mapStyle != .imagery {
                ToggleControl(label: "Show Traffic", isOn: $showsTraffic)
            }
        }
    }

    private var generatedCode: String {
        let styleCode: String
        switch mapStyle {
        case .standard:
            styleCode = ".standard(elevation: \(elevation == .realistic ? ".realistic" : ".flat"), showsTraffic: \(showsTraffic))"
        case .imagery:
            styleCode = ".imagery(elevation: \(elevation == .realistic ? ".realistic" : ".flat"))"
        case .hybrid:
            styleCode = ".hybrid(elevation: \(elevation == .realistic ? ".realistic" : ".flat"), showsTraffic: \(showsTraffic))"
        }

        return """
        import MapKit

        Map {
            // Map content (markers, annotations)
        }
        .mapStyle(\(styleCode))
        """
    }
}

#Preview {
    NavigationStack {
        MapBasicsPlayground()
    }
}
