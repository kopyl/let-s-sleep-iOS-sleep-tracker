import SwiftUI

struct Icons {
    static func plus(color: Color = _Color.blue) -> some View {
        Image(systemName: IconNames.plus.rawValue)
            .foregroundColor(color)
                .font(.system(size: 16))
        }
    
    static func confirm() -> some View {
        Image(systemName: IconNames.confirm.rawValue)
            .foregroundColor(_Color.blue)
                .font(.system(size: 16))
        }
    
    static func sleepEvent(type: SleepEventType) -> some View {
        switch type {
        case .goToSleep:
            return AnyView(
                Image(systemName: IconNames.bed.rawValue)
                    .foregroundColor(_Color.blue)
                        .font(.system(size: 13))
            )
        case .wakeUp:
            return AnyView(
                Image(systemName: IconNames.sun.rawValue)
                    .foregroundColor(_Color.yellow)
                        .font(.system(size: 13))
            )
        }
    }
}
