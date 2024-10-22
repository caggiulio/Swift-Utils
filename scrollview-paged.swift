/// A custom SwiftUI view that displays two horizontally scrollable, full-screen colored cards
/// with animations based on scroll transitions. Each card adjusts its scale, blur, and grayscale
/// effect as the user scrolls through the view.
///
/// This view uses a `GeometryReader` to dynamically adapt the size of its child views based on
/// the size of the containing view. The content inside the scroll view is composed of a
/// `LazyHStack`, which efficiently loads and manages horizontally arranged child views.
///
/// - The first card is red and applies padding to the top and bottom safe areas.
/// - The second card is yellow and applies padding only to the top safe area.
/// - Both cards transition with scale, blur, and grayscale effects when scrolled.
/// - The scroll view is configured with `.viewAligned` behavior, ensuring smooth alignment
///   to the center of the view when scrolling.
///
/// The `safeAreaPadding` modifier ensures that the views respect the device's safe areas,
/// while `.scrollTransition` provides a visually appealing effect during scroll transitions.
///
/// This view does not take any external parameters and is designed to fill the available space
/// using the `GeometryReader` for dynamic layout, ensuring that the cards scale and adapt
/// to different screen sizes.
///
/// - Important: This view respects safe areas through the use of `safeAreaPadding`, but the
///   background color will ignore the safe area to create a full-screen effect.
///
/// Example:
/// ```swift
/// ScrolledPageView()
/// ```
///
struct ScrolledPageView: SwiftUI.View {
    var body: some SwiftUI.View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    Color.red
                        .safeAreaPadding([.bottom, .top], .medium)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .cornerRadius(50)
                        .scrollTransition { view, phase in
                            view
                                .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                .blur(radius: phase.isIdentity ? .zero: 5)
                                .grayscale(phase.isIdentity ? .zero : 1)
                        }
                    
                    Color.yellow
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
        .background(Color.background)
        .ignoresSafeArea()
    }
}
