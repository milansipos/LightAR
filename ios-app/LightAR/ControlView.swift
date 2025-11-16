
import SwiftUI

struct ControlView: View {
    @Binding var isControlsVisible: Bool
    var body: some View {
        VStack {
            
            ControlVisibilityToggleButton(isControlsVisible: $isControlsVisible)
            
            Spacer()
            
            if (isControlsVisible) {
                ControlButtonBar()
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
    var body: some View {
        HStack {
            
            ControlButton(imageName: "clock.fill", action: {
                print("Recent was pressed")
            })
            
            Spacer()
            
            ControlButton(imageName: "square.grid.2x2") { print("browse was pressed") }
         
            Spacer()
            
            ControlButton(imageName: "slider.horizontal.3") {print("settings was pressed")}
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

#Preview {
    ControlView(isControlsVisible: .constant(true))
}
