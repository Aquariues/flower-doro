# Flower-doro

Flower-doro is a tiny Pomodoro garden app for iPhone and macOS.

The first idea:

- Set a work countdown and break countdown, for example 30 minutes work and 5 minutes break.
- Finish a work session.
- Earn a flower.
- Grow a small garden from completed focus sessions.

## Project Shape

This repo starts as a Swift package that contains shared SwiftUI views and app logic for iOS and macOS.

Next step in Xcode:

1. Create a new iOS App target named `FlowerDoro`.
2. Create a new macOS App target named `FlowerDoroMac`.
3. Add this package as local shared code.
4. Use `FlowerDoroRootView()` as the first screen in both apps.

Keeping the timer and garden code in a package lets the iPhone and macOS apps share behavior from day one.

## Development

Run tests:

```sh
swift test
```
