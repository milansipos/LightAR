
import SwiftUI

struct ControlView: View {
    @Binding var isControlsVisible: Bool
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack {
            
            ControlVisibilityToggleButton(isControlsVisible: $isControlsVisible)
            
            Spacer()
            
            if (isControlsVisible) {
                ControlButtonBar(showBrowse: $showBrowse, showSettings: $showSettings)
            }
        }
    }
}

struct ControlVisibilityToggleButton: View {
    @Binding var isControlsVisible: Bool
    var body: some View {
        
        HStack {
            
            Spacer()
            
            ZStack {
                Color.black.opacity(0.20)
                
                Button(action: {
                    isControlsVisible.toggle()
                }) {
                    Image(systemName: isControlsVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                        .font(.title)
                        .foregroundStyle(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding(.top, 45)
        .padding(.trailing, 20)
    }
}

struct ControlButtonBar: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        HStack {
            
            mostRecentlyPlacedButton().hidden(self.placementSettings.recentlyPlaced.isEmpty)
            
            Spacer()
            
            ControlButton(imageName: "square.grid.2x2") {
                print("browse was pressed")
                showBrowse.toggle()
            }
                .sheet(isPresented: $showBrowse, content: {
                    BrowseView(showBrowse: $showBrowse)
                })
         
            Spacer()
            
            ControlButton(imageName: "slider.horizontal.3") {
                showSettings.toggle()
            }
            .sheet(isPresented: $showSettings, content: {
                SettingsView(showSettings: $showSettings)
            })
        }
        .frame(maxWidth: 500)
        .padding(.horizontal, 50)
        .padding(.top, 20)
        .padding(.bottom, 50)
        .background(Color.black.opacity(0.2))
    }
}

struct ControlButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
    }
}

struct mostRecentlyPlacedButton : View {
    @EnvironmentObject var placementSettings: PlacementSettings
    var body: some View {
        Button(action: {
            print("recent button pressed")
            self.placementSettings.selectedModel = self.placementSettings.recentlyPlaced.last
        }) {
            if let mostRecentlyPlacedModel = self.placementSettings.recentlyPlaced.last {
                Image(uiImage: mostRecentlyPlacedModel.thumbnail)
                    .resizable()
                    .frame(width:45)
                    .aspectRatio(1/1, contentMode: .fit)
            } else {
                Image(systemName: "clock.fill")
                    .foregroundStyle(.white)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 50, height: 50)
        .backgroundStyle(.white)
        .cornerRadius(8.0)
    }
}

