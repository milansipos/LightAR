
import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
    case table
    case chair
    case decor
    case light
    case shelf
    
    var label: String {
        get{
            switch self {
            case .table:
                return "Tables"
            case .chair:
                return "Chairs"
            case .decor:
                return "Decor"
            case .light:
                return "Lights"
            case .shelf:
                return "Shelves"
            }
        }
    }
}

class TextureModel {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    func asyncLoadModelEntity() {
        let filename = "\(name).usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error): print("Unable to load modelEntity. Filename \(filename) with error: \(error)")
                case .finished:
                    break
                }}, receiveValue: {modelEntity in
                    self.modelEntity = modelEntity
                    self.modelEntity?.scale += self.scaleCompensation
                    
                    print("\(self.name) modelentity loaded!")
                })
    }
    //TODO: load async modelentity
}

struct TextureModels {
    var all: [TextureModel] = []
    
    init() {
        // Shelves
        let birchShelf = TextureModel(name: "birch_shelf", category: .shelf, scaleCompensation: 0.32/100)
        let oakShelf = TextureModel(name: "oak_shelf", category: .shelf, scaleCompensation: 0.32/100)
        // Lights
        let tableLamp = TextureModel(name: "table_lamp", category: .light, scaleCompensation: 0.32/100)
        let leverLamp = TextureModel(name: "lever_lamp", category: .light, scaleCompensation: 0.32/100)
        //Chairs
        let modernChair = TextureModel(name: "modern_chair", category: .chair, scaleCompensation: 0.32/100)
        let oakChair = TextureModel(name: "oak_chair", category: .chair, scaleCompensation: 0.32/100)
        self.all += [birchShelf, oakShelf, tableLamp, leverLamp, modernChair, oakChair]
    }
    func get(category: ModelCategory) -> [TextureModel] {
        return all.filter( { $0.category == category })
    }
}

