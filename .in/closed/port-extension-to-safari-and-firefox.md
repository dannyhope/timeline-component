# Port extension to Safari and Firefox
**Readiness:** auto-refined

This repository is currently an HTML/CSS/JavaScript timeline component, not a browser extension. If it later becomes or incorporates an extension, port the extension to Safari and Firefox.

## Scope

- Confirm the extension architecture and browser APIs in use.
- Add Safari support, including any required App Extension packaging and entitlements.
- Add Firefox support, including manifest and API compatibility changes.
- Keep the Chrome implementation working.
- Document build, signing, testing, and store submission steps.
- Test the main user journeys in Chrome, Safari, and Firefox.

## Auto-investigation
**Investigated:** 2026-09-03

### Findings
- The repository is a standalone HTML/CSS/JavaScript timeline component, with `timeline.html`, `timeline.css`, and `timeline.js`; it contains no browser-extension manifest, background/content scripts, browser API usage, Safari App Extension target, Xcode project, entitlements, or extension build tooling.
- The product contract is HTML-first: the table is the data and `timeline.js` enhances it. The timeline skill explicitly says not to port it to React or rewrite the renderer.
- Current documentation describes browser rendering and playground/product surfaces, but does not define an extension product, user journey, permissions model, packaging target, or distribution requirements.

### Scope
- This cannot be implemented against the current codebase as a direct compatibility port: an extension architecture and product purpose would need to be established first.
- Likely future scope includes choosing an extension surface and architecture, introducing a Chrome manifest/build path, then adding Firefox manifest/API compatibility and a Safari Web Extension/App Extension packaging path with Apple signing and entitlements.
- Estimated complexity: large.
- Docs impact: `_docs/spec.md` and `_docs/design.md` would need to define the extension surface and behaviour; implementation/build and submission documentation would also need to be added once the architecture exists.

### Proposed implementation
1. Define the extension’s concrete user-facing job, supported browsers/versions, entry points, permissions, data flow, and whether the existing timeline page is embedded, injected, or opened as a browser action.
2. Establish a canonical WebExtension source and build process, keeping the existing HTML-first timeline renderer as the shared UI where applicable.
3. Add Firefox manifest/API compatibility and automated Chrome/Firefox tests, then package the same WebExtension for Safari with the required Xcode App Extension target, entitlements, signing, and packaging checks.
4. Document local builds, signing, testing, and store submission steps, and run the main user journeys in all three browsers.
- The key risk is starting Safari/Firefox work before there is a Chrome extension to preserve; packaging and permissions decisions materially affect the architecture and implementation sequence.

### Questions for refinement
1. **What extension product should be ported?** This repository has no current extension; specify the user job and whether the timeline is injected into pages, opened as a browser action, or used through another surface.

   **Answer:**

2. **What is the source Chrome implementation and target support matrix?** Identify the Chrome repository/branch and minimum Chrome, Firefox, and Safari versions to support.

   **Answer:**

3. **What permissions and data handling are required?** Define host permissions, storage/network access, privacy constraints, and whether the extension must work offline.

   **Answer:**

4. **What Safari distribution target is required?** Choose Safari Web Extension packaging only, or a signed macOS/iOS App Extension, and identify the intended store or sideloading route.

   **Answer:**

### Documentation impact
- Update `_docs/spec.md` and `_docs/design.md` once the extension product, surfaces, and behaviour are defined.
- Add implementation/build/signing/submission documentation for the chosen WebExtension and Safari packaging architecture.

### Related items
- _(parent will fill)_
