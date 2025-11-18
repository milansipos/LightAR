
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
    @EnvironmentObject var placementSettings: PlacementSettings
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self) { (event) in
        
            updateScene(for: arView)
            
        }
        
        return arView
    }
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    private func updateScene(for arView: CustomARView) {
        
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            
            place(modelEntity, in: arView)
            
            self.placementSettings.confirmedModel = nil
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView) {
        
        // Clone modelentity to allow having same asset multiple times in scene
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
        // create anchor and add clone as its child
        let anchor = AnchorEntity(plane: .any)
        anchor.addChild(clonedEntity)
        
        // add anchor entity to scene
        arView.scene.addAnchor(anchor)
    }
    
}

#Preview {
    ContentView()
        .environmentObject(PlacementSettings())
}
