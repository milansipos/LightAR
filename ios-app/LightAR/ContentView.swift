
import SwiftUI
import RealityKit

struct ContentView : View {
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
        ZStack {
            ARViewContainer()
            
            ControlView(isControlsVisible: $isControlVisible, showBrowse: $showBrowse)
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
}
