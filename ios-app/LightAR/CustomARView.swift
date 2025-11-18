
import SwiftUI
import RealityKit
import FocusEntity
import ARKit
import Combine

class CustomARView : ARView {
    
    var focusEntity: FocusEntity?
    var sessionSettings: SessionSettings
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var lidarDebugCancellable: AnyCancellable?
    private var multiuserCancellable: AnyCancellable?

    
    required init(frame frameRect: CGRect, sessionSettings: SessionSettings) {
        self.sessionSettings = sessionSettings
        
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
        
        initializeSettings()
        
        setupSubscribers()
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("old construcotr of customarview, use the new one")
    }
    
    @MainActor @preconcurrency required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        session.run(config)
    }
    
    private func initializeSettings() {
        self.updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcclusionEnabled)
        self.updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcclusionEnabled)

        self.updateLidarDebug(isEnabled: sessionSettings.isLidarEnabled)
        self.updateMultiuser(isEnabled: sessionSettings.isMultiUserEnabled)

    }
     
    private func setupSubscribers() {
        self.peopleOcclusionCancellable =  sessionSettings.$isPeopleOcclusionEnabled.sink { [weak self] isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
        
        self.objectOcclusionCancellable =  sessionSettings.$isPeopleOcclusionEnabled.sink { [weak self] isEnabled in
            self?.updateObjectOcclusion(isEnabled: isEnabled)
        }
        
        self.lidarDebugCancellable =  sessionSettings.$isPeopleOcclusionEnabled.sink { [weak self] isEnabled in
            self?.updateLidarDebug(isEnabled: isEnabled)
        }
        
        self.multiuserCancellable =  sessionSettings.$isPeopleOcclusionEnabled.sink { [weak self] isEnabled in
            self?.updateMultiuser(isEnabled: isEnabled)
        }
    }
    
    private func updatePeopleOcclusion(isEnabled: Bool) {
        //Todo
        
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            return
        }
        guard let config = self.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        
        if config.frameSemantics.contains(.personSegmentationWithDepth) {
            config.frameSemantics.remove(.personSegmentationWithDepth)
        } else {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        session.run(config)
        
    }
    private func updateObjectOcclusion(isEnabled: Bool) {
        //Todo
        if self.environment.sceneUnderstanding.options.contains(.occlusion) {
            self.environment.sceneUnderstanding.options.remove(.occlusion)
        } else {
            self.environment.sceneUnderstanding.options.insert((.occlusion))
        }
    }
    private func updateLidarDebug(isEnabled: Bool) {
        if self.debugOptions.contains(.showSceneUnderstanding) {
            self.debugOptions.remove(.showSceneUnderstanding)
        } else {
            self.debugOptions.insert(.showSceneUnderstanding)
        }
    }
    private func updateMultiuser(isEnabled: Bool) {
        //Todo
    }
    
    
    
}
