import SwiftUI

class Buttons {
    struct BaseButton: View {
        let icon: (any View)?
        let text: String?
        let foregroundColor: Color
        let bgColor: Color
        let bgOpacity: Double
        let action: () -> Void
        
        init(icon: (any View)? = nil, text: String? = nil, foregroundColor: Color, bgColor: Color? = nil, bgOpacity: Double = 0.08, action: @escaping () -> Void) {
            self.icon = icon
            self.text = text
            self.foregroundColor = foregroundColor
            self.bgColor = bgColor ?? foregroundColor
            self.bgOpacity = bgOpacity
            self.action = action
        }

        var body: some View {
            Button(action: action) {
                HStack(spacing: 16) {
                    if let icon {
                        AnyView(icon)
                    }
                    if let text {
                        Text(text)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
            }
            .font(.system(size: 13))
            .foregroundColor(foregroundColor)
            .background(bgColor.opacity(bgOpacity))
            .cornerRadius(5)
            .padding(.bottom, 17)
        }
    }
    
    struct AddFirstEntry: View {
        let text: String?
        var action: () -> Void
        
        init(text: String? = nil, action: @escaping () -> Void) {
            self.text = text
            self.action = action
        }
        
        var body: some View {
            BaseButton(
                icon: Icons.plus(color: .white),
                text: text ?? buttonsCopy.addFirstEntry.rawValue,
                foregroundColor: .white,
                bgColor: _Color.blue,
                bgOpacity: 1,
                action: action
            )
        }
    }
    
    struct GoToSleep: View {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        var body: some View {
            BaseButton(
                icon: Icons.sleepEvent(type: .wentToSleep),
                text: buttonsCopy.goToSleep.rawValue,
                foregroundColor: _Color.blue,
                action: action
            )
        }
    }
    
    struct Confirm: View {
        let action: () -> Void
        let text: String = "Confirm"
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        var body: some View {
            BaseButton(
                icon: Icons.confirm(),
                text: text,
                foregroundColor: _Color.blue,
                action: action
            )
        }
    }
    
    struct Cancel: View {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        var body: some View {
            BaseButton(
                text: buttonsCopy.cancel.rawValue,
                foregroundColor: .red,
                action: action
            )
        }
    }
    
    struct WakeUp: View {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        var body: some View {
            BaseButton(
                icon: Icons.sleepEvent(type: .wokeUp),
                text: buttonsCopy.wakeUp.rawValue,
                foregroundColor: _Color.yellow,
                action: action
            )
        }
    }
    
    struct Plus: View {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        var body: some View {
            BaseButton(
                icon: Icons.plus(),
                foregroundColor: _Color.blue,
                action: action
            )
            .frame(
                maxWidth: 46)
        }
    }
}
