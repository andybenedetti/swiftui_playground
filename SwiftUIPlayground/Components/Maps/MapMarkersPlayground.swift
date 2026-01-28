import SwiftUI
import MapKit

struct MapMarkersPlayground: View {
    @State private var markerStyle = MarkerStyle.marker
    @State private var showMultiple = true
    @State private var tintColor: Color = .red

    enum MarkerStyle: String, CaseIterable {
        case marker = "Marker"
        case annotation = "Annotation"
        case mixed = "Mixed"
    }

    struct Location: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
        let icon: String
    }

    let locations: [Location] = [
        Location(name: "Ferry Building", coordinate: CLLocationCoordinate2D(latitude: 37.7955, longitude: -122.3937), icon: "building.columns"),
        Location(name: "Coit Tower", coordinate: CLLocationCoordinate2D(latitude: 37.8024, longitude: -122.4058), icon: "building"),
        Location(name: "Fisherman's Wharf", coordinate: CLLocationCoordinate2D(latitude: 37.8080, longitude: -122.4177), icon: "fish"),
    ]

    let singleLocation = CLLocationCoordinate2D(latitude: 37.7955, longitude: -122.3937)

    var body: some View {
        ComponentPage(
            title: "Map Markers",
            description: "Add markers and annotations to maps.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/mapkit/marker")!,
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
            mapView
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder
    private var mapView: some View {
        switch markerStyle {
        case .marker:
            if showMultiple {
                Map {
                    ForEach(locations) { location in
                        Marker(location.name, coordinate: location.coordinate)
                            .tint(tintColor)
                    }
                }
            } else {
                Map {
                    Marker("Ferry Building", coordinate: singleLocation)
                        .tint(tintColor)
                }
            }
        case .annotation:
            if showMultiple {
                Map {
                    ForEach(locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: location.icon)
                                .padding(8)
                                .background(tintColor)
                                .foregroundStyle(.white)
                                .clipShape(Circle())
                        }
                    }
                }
            } else {
                Map {
                    Annotation("Ferry Building", coordinate: singleLocation) {
                        Image(systemName: "building.columns")
                            .padding(8)
                            .background(tintColor)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                    }
                }
            }
        case .mixed:
            Map {
                Marker("Ferry Building", coordinate: locations[0].coordinate)
                    .tint(.red)

                Marker("Coit Tower", systemImage: "building", coordinate: locations[1].coordinate)
                    .tint(.blue)

                Annotation("Wharf", coordinate: locations[2].coordinate) {
                    VStack {
                        Image(systemName: "fish")
                            .padding(6)
                            .background(.orange)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Text("🦀")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $markerStyle,
                options: MarkerStyle.allCases,
                optionLabel: { $0.rawValue }
            )

            if markerStyle != .mixed {
                ToggleControl(label: "Multiple Markers", isOn: $showMultiple)
                ColorControl(label: "Tint", color: $tintColor)
            }
        }
    }

    private var generatedCode: String {
        switch markerStyle {
        case .marker:
            if showMultiple {
                return """
                import MapKit

                struct Location: Identifiable {
                    let id = UUID()
                    let name: String
                    let coordinate: CLLocationCoordinate2D
                }

                let locations: [Location] = [...]

                Map {
                    ForEach(locations) { location in
                        Marker(location.name, coordinate: location.coordinate)
                            .tint(.red)
                    }
                }
                """
            } else {
                return """
                import MapKit

                let coordinate = CLLocationCoordinate2D(
                    latitude: 37.7955,
                    longitude: -122.3937
                )

                Map {
                    Marker("Ferry Building", coordinate: coordinate)
                        .tint(.red)
                }
                """
            }
        case .annotation:
            return """
            import MapKit

            Map {
                Annotation("Location", coordinate: coordinate) {
                    Image(systemName: "building.columns")
                        .padding(8)
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
            }
            """
        case .mixed:
            return """
            import MapKit

            Map {
                // Standard marker
                Marker("Place 1", coordinate: coord1)
                    .tint(.red)

                // Marker with custom icon
                Marker("Place 2", systemImage: "building", coordinate: coord2)
                    .tint(.blue)

                // Custom annotation view
                Annotation("Place 3", coordinate: coord3) {
                    Image(systemName: "star.fill")
                        .padding(6)
                        .background(.orange)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        MapMarkersPlayground()
    }
}
