
import SwiftUI
import RealityKit
import Combine

class PlacementSettings : ObservableObject {
    
    // if user selects model in BrowseView, this property is set
    @Published var selectedModel: TextureModel? {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    // if user confirms in PlacementView, the value of selectedModel is assigned to Confirmedmodel
    @Published var confirmedModel: TextureModel? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            print("Setting confirmedModel to \(model.name)")
            self.recentlyPlaced.append(model)
        }
    }
    
    // record of most recently placed models bigger index more recent
    @Published var recentlyPlaced: [TextureModel] = []
    
    // cancellable object for SceneEvents.update Subscriber
    var sceneObserver : Cancellable?
    
}
