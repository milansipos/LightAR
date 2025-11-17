
import SwiftUI
import RealityKit

struct ContentView : View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlVisible = true
    @State private var showBrowse = false

    var body: some View {
        
        VStack {
            Image(systemName: "heart.circle.fill")
                .foregroundStyle(.red)
                .font(.system(size: 50))
            Text("LightAr")
                .font(.system(size: 30))
        }
        ZStack(alignment: .bottom) {
            ARViewContainer()
            
            if self.placementSettings.selectedModel == nil {
                ControlView(isControlsVisible: $isControlVisible, showBrowse: $showBrowse)
            } else {
                PlacementView()
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }

}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}

#Preview {
    ContentView()
        .environmentObject(PlacementSettings())
}
