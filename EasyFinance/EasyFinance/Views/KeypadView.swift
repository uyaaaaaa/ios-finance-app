import SwiftUI

// MARK: - Keypad Configuration (Single Responsibility)
struct KeypadConfiguration {
    let buttonSize: CGFloat
    let spacing: CGFloat
    let cornerRadius: CGFloat
    
    static let standard = KeypadConfiguration(
        buttonSize: 70,
        spacing: 12,
        cornerRadius: 16
    )
}

// MARK: - Keypad Button Styles (Open/Closed Principle)
struct NumberButtonStyle: ButtonStyle {
    let config: KeypadConfiguration
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .fontWeight(.semibold)
            .frame(width: config.buttonSize, height: config.buttonSize)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ActionButtonStyle: ButtonStyle {
    let config: KeypadConfiguration
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .foregroundColor(.primary)
            .frame(width: config.buttonSize, height: config.buttonSize)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    let config: KeypadConfiguration
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 32))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(
                width: config.buttonSize,
                height: config.buttonSize * 3 + config.spacing * 2
            )
            .background(isDisabled ? Color.gray.opacity(0.3) : Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Keypad Button Components (Single Responsibility)
struct NumberButton: View {
    let number: String
    let config: KeypadConfiguration
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(number)
        }
        .buttonStyle(NumberButtonStyle(config: config))
    }
}

struct DeleteButton: View {
    let config: KeypadConfiguration
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "delete.left")
        }
        .buttonStyle(ActionButtonStyle(config: config))
    }
}

struct CommitButton: View {
    let config: KeypadConfiguration
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "checkmark")
        }
        .buttonStyle(PrimaryButtonStyle(config: config, isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

// MARK: - Number Grid (Single Responsibility)
struct NumberGrid: View {
    let config: KeypadConfiguration
    let onNumberTap: (String) -> Void
    
    var body: some View {
        VStack(spacing: config.spacing) {
            // Rows 1-3: Numbers 1-9
            ForEach(0..<3) { row in
                HStack(spacing: config.spacing) {
                    ForEach(1...3, id: \.self) { col in
                        let number = row * 3 + col
                        NumberButton(
                            number: "\(number)",
                            config: config,
                            action: { onNumberTap("\(number)") }
                        )
                    }
                }
            }
            
            // Row 4: Empty, 0, Empty
            HStack(spacing: config.spacing) {
                Spacer()
                    .frame(width: config.buttonSize, height: config.buttonSize)
                
                NumberButton(
                    number: "0",
                    config: config,
                    action: { onNumberTap("0") }
                )
                
                Spacer()
                    .frame(width: config.buttonSize, height: config.buttonSize)
            }
        }
    }
}

// MARK: - Action Column (Single Responsibility)
struct ActionColumn: View {
    let config: KeypadConfiguration
    let isDoneDisabled: Bool
    let onDelete: () -> Void
    let onCommit: () -> Void
    
    var body: some View {
        VStack(spacing: config.spacing) {
            DeleteButton(config: config, action: onDelete)
            CommitButton(config: config, isDisabled: isDoneDisabled, action: onCommit)
        }
    }
}

// MARK: - Main Keypad View (Composition)
struct KeypadView: View {
    @Binding var text: String
    var isDoneDisabled: Bool = false
    var onCommit: (() -> Void)? = nil
    
    private let config = KeypadConfiguration.standard
    
    var body: some View {
        HStack(alignment: .top, spacing: config.spacing) {
            NumberGrid(config: config, onNumberTap: appendNumber)
            
            ActionColumn(
                config: config,
                isDoneDisabled: isDoneDisabled,
                onDelete: deleteLast,
                onCommit: { onCommit?() }
            )
        }
        .padding()
        .foregroundColor(.primary)
    }
    
    // MARK: - Business Logic (Dependency Inversion)
    private func appendNumber(_ number: String) {
        if text == "0" {
            text = number
        } else {
            text.append(number)
        }
    }
    
    private func deleteLast() {
        if !text.isEmpty {
            text.removeLast()
        }
    }
}

// MARK: - Preview
#Preview {
    KeypadView(text: .constant("123"))
}
