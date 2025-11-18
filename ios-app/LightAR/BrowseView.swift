
import SwiftUI

struct BrowseView: View {
    
    @Binding var showBrowse: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators:false) {
                
                RecentsGrid(showBrowse: $showBrowse)
                
                ModelsByCategoryGrid(showBrowse: $showBrowse)
            }
            .navigationTitle(Text("Browse"))
            .navigationBarItems(trailing: Button("Done") {
                showBrowse.toggle()
            })
        }
    }
}

struct RecentsGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    
    var body: some View {
        if !self.placementSettings.recentlyPlaced.isEmpty {
            HorizontalGrid(title: "Recents", items: getRecentsUniqueOrdered(), showBrowse: $showBrowse)
        }
    }
    
    func getRecentsUniqueOrdered() -> [TextureModel] {
        var recentsUniqueOrderedArray: [TextureModel] = []
        var modelNameSet: Set<String> = []
        
        for model in self.placementSettings.recentlyPlaced.reversed() {
            if !modelNameSet.contains(model.name) {
                recentsUniqueOrderedArray.append(model)
                modelNameSet.insert(model.name)
            }
        }
        return recentsUniqueOrderedArray
    }
    
}

struct ModelsByCategoryGrid: View {
    
    let models =  TextureModels()
    @Binding var showBrowse: Bool

    
    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                let modelsByCategory = models.get(category: category)
                
                if !modelsByCategory.isEmpty {
                    HorizontalGrid(title: category.label, items: modelsByCategory, showBrowse: $showBrowse)
                }
            }
        }
    }
    
    
}

struct HorizontalGrid : View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    private let gridItemLayout = [GridItem(.fixed(150))]
    var title: String
    var items: [TextureModel]
    @Binding var showBrowse: Bool

    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.title2).bold()
                .padding(.leading, 22)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout, spacing: 30) {
                    ForEach(0..<items.count) { index in
                        
                        let model = items[index]
                        ModelButton(model: model) {
                            model.asyncLoadModelEntity()
                            
                            self.placementSettings.selectedModel = model
                            showBrowse.toggle()
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            }
        }
    }
}

struct ModelButton: View {
    let model: TextureModel
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(uiImage: self.model.thumbnail)
                .resizable()
                .frame(height: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
        }
    }
}

struct Separator: View {
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}
