import SwiftUI
import MapKit

struct MapCameraPlayground: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedCity = City.sanFrancisco
    @State private var distance: Double = 5000
    @State private var pitch: Double = 0
    @State private var heading: Double = 0

    enum City: String, CaseIterable {
        case sanFrancisco = "San Francisco"
        case newYork = "New York"
        case london = "London"
        case tokyo = "Tokyo"

        var coordinate: CLLocationCoordinate2D {
            switch self {
            case .sanFrancisco:
                CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            case .newYork:
                CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
            case .london:
                CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
            case .tokyo:
                CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503)
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "Map Camera",
            description: "Control map camera position, pitch, and heading.",
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
            Map(position: $cameraPosition) {
                Marker(selectedCity.rawValue, coordinate: selectedCity.coordinate)
            }
            .frame(height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onChange(of: selectedCity) { _, newCity in
                withAnimation {
                    updateCamera(for: newCity)
                }
            }
            .onChange(of: distance) { _, _ in
                withAnimation {
                    updateCamera(for: selectedCity)
                }
            }
            .onChange(of: pitch) { _, _ in
                withAnimation {
                    updateCamera(for: selectedCity)
                }
            }
            .onChange(of: heading) { _, _ in
                withAnimation {
                    updateCamera(for: selectedCity)
                }
            }
            .onAppear {
                updateCamera(for: selectedCity)
            }
        }
    }

    private func updateCamera(for city: City) {
        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: city.coordinate,
                distance: distance,
                heading: heading,
                pitch: pitch
            )
        )
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "City",
                selection: $selectedCity,
                options: City.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Distance",
                value: $distance,
                range: 1000...50000,
                format: "%.0fm"
            )

            SliderControl(
                label: "Pitch",
                value: $pitch,
                range: 0...60,
                format: "%.0f°"
            )

            SliderControl(
                label: "Heading",
                value: $heading,
                range: 0...360,
                format: "%.0f°"
            )
        }
    }

    private var generatedCode: String {
        """
        import MapKit

        @State private var position: MapCameraPosition = .camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: \(String(format: "%.4f", selectedCity.coordinate.latitude)),
                    longitude: \(String(format: "%.4f", selectedCity.coordinate.longitude))
                ),
                distance: \(Int(distance)),
                heading: \(Int(heading)),
                pitch: \(Int(pitch))
            )
        )

        Map(position: $position) {
            Marker("\(selectedCity.rawValue)", coordinate: coordinate)
        }
        """
    }
}

#Preview {
    NavigationStack {
        MapCameraPlayground()
    }
}
