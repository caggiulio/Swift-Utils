var body: some SwiftUI.View {
      GeometryReader { geometry in
        ScrollView(.horizontal) {
          LazyHStack(spacing: 0) {
            UI.Authentication.View(animation: Namespace().wrappedValue)
              .safeAreaPadding([.bottom, .top], .medium)
              .frame(width: geometry.size.width, height: geometry.size.height)
              .cornerRadius(50)
              .scrollTransition { view, phase in
                view
                  .scaleEffect(phase.isIdentity ? 1 : 0.95)
                  .blur(radius: phase.isIdentity ? .zero: 5)
                  .grayscale(phase.isIdentity ? .zero : 1)
              }
            
            UI.Splash.View(animation: Namespace().wrappedValue)
              .safeAreaPadding([.top], .medium)
              .frame(width: geometry.size.width, height: geometry.size.height)
              .cornerRadius(50)
              .scrollTransition { view, phase in
                view
                  .scaleEffect(phase.isIdentity ? 1 : 0.95)
                  .blur(radius: phase.isIdentity ? .zero: 5)
                  .grayscale(phase.isIdentity ? .zero : 1)
              }
          }
          .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
      }
      .background(Color.yesDearBackground)
      .ignoresSafeArea()
    }