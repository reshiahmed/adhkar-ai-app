import SwiftUI

struct MasterySummaryBadge: View {
    let pct: Int
    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 52, height: 52)
                .overlay {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 0.5)
                }

            Circle()
                .stroke(Color.primaryGreen.opacity(0.1), lineWidth: 3)
                .frame(width: 52, height: 52)
            
            Circle()
                .trim(from: 0, to: CGFloat(pct) / 100.0)
                .stroke(Color.primaryGreen, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 52, height: 52)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: pct)
            
            VStack(spacing: 0) {
                Text("\(pct)%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                Text("TOTAL")
                    .font(.system(size: 6, weight: .black))
                    .foregroundColor(.primaryGreen)
            }
        }
    }
}
