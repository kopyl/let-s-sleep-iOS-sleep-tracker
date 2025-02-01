import SwiftUI

struct CircularBlurBackground: View {
    let sleepStatus: SleepStatus
    
    var body: some View {
        VStack{
            Spacer()
            Circle()
                .fill(sleepStatus == .awake ? _Color.yellow: _Color.blue)
                .blur(radius: 300)
        }
        .padding(.bottom, 183)
    }
}
