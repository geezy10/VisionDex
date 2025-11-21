# VisionDex: Spatial Research 🥽✨

**VisionDex** is a fully immersive spatial computing application built for Apple Vision Pro. It reimagines the classic Pokédex as a holographic laboratory, allowing users to research, interact with, and study creatures in their physical environment using advanced visionOS capabilities.

This project builds upon the data foundation of [Pokedex-Repo](https://github.com/geezy10/Pokedex) but leverages the full power of RealityKit and Spatial Computing.

---

## 🌟 Key Features

This project implements a comprehensive set of visionOS technologies:

### 🏗️ Spatial & Environmental
* **Full Space Immersion:** Transitions from windowed UI to a fully immersive environment tailored to the creature's type (e.g., water effects for aquatic types).
* **World Tracking & Scene Reconstruction:** Creatures interact with the physical room. They can land on tables, hide behind sofas, and respect physical boundaries using ARKit scene understanding.
* **Physics & Collisions:** Real-world physics simulation. Throw virtual berries that bounce off physical furniture to feed creatures.

### 🛠️ Architecture & Tech Stack
* **ECS (Entity Component System):** Built on RealityKit’s ECS architecture. Each creature is an entity with modular components for `Hunger`, `Type`, and `Behavior`.
* **SwiftUI & visionOS:** Extensive use of **Ornaments** for the control interface, **Glass Backgrounds**, and native **Hover Effects** for eye-tracking interactions.

### 🤏 Interaction & Accessibility
* **Hand Tracking:** Controller-free interaction. Use custom gestures to pet creatures or navigate the UI.
* **Accessibility:** Full support for VoiceOver and Dynamic Type within the spatial UI.

### 🎭 Animation & Visuals
* **Reality Composer Pro (RCP):** Centralized scene assembly.
* **Timeline Animations:** Complex animation states (Idle, Eat, Attack) orchestrated via RCP Timelines and triggered by Swift code.

---

## 🚀 Getting Started

### Prerequisites
* Xcode 15.2+ (visionOS SDK installed)
* Apple Vision Pro Simulator or Device

### Installation
1.  Clone the repository.
2.  Open `VisionDex.xcodeproj`.
3.  Wait for Reality Composer Pro packages to resolve.
4.  Build and Run targeting **Apple Vision Pro**.

---

## 📂 Project Structure

* `/Packages/CreatureAssets`: Contains the Reality Composer Pro project with 3D models, custom shaders, and audio.
* `/VisionDex/ECS`: Contains all Systems and Components (e.g., `HungerSystem.swift`).
* `/VisionDex/Views`: SwiftUI interfaces (Ornaments and Windows).

---

## ⚠️ Disclaimer
This is a non-commercial educational project exploring the capabilities of visionOS. Pokémon is a trademark of Nintendo/Creatures Inc./GAME FREAK inc. Assets are used for research/educational purposes only.
