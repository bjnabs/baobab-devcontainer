/******************************************************************************
 * BAOBAB Development Container
 ******************************************************************************
 *
 * File
 * ----
 * assets/javascripts/extra.js
 *
 * Purpose
 * -------
 * Provides custom JavaScript enhancements for the BAOBAB documentation site.
 *
 * The MkDocs Material theme already provides an excellent user experience.
 * This file exists as an extension point for BAOBAB-specific functionality and
 * should remain lightweight.
 *
 * Design Principles
 * -----------------
 * • Prefer native browser APIs.
 * • Avoid external JavaScript libraries.
 * • Keep functionality modular.
 * • Preserve accessibility.
 * • Do not modify Material behaviour unless necessary.
 *
 * Instant Navigation
 * -------------------
 * mkdocs.yml enables theme.features -> navigation.instant, which intercepts
 * internal link clicks and swaps page content via XHR instead of a full
 * browser reload. Under that mode, `DOMContentLoaded` fires exactly once per
 * browser session — never again on subsequent in-app navigation. Any
 * initialization that needs to re-run per page view (which is everything
 * below) MUST bind to Material's own `document$` observable instead. See
 * Material's customization docs, "Additional JavaScript" section. A
 * DOMContentLoaded fallback is kept below purely as a defensive no-op path;
 * it should never actually be exercised while navigation.instant stays
 * enabled.
 *
 * Currently Implemented
 * ----------------------
 * • Landing page hero entrance (.slide-up, see animations.css)
 * • Landing page scroll-triggered card reveal (.fade-in, see animations.css)
 * • Reduced-motion-aware smooth in-page anchor scrolling
 *
 * Each function below is defensively scoped: it queries for the elements it
 * needs and no-ops if they aren't present on the current page, so this file
 * stays safe to load site-wide via extra_javascript rather than needing to
 * be conditionally included per page.
 *
 * Future Enhancements
 * -------------------
 * Planned additions may include:
 *
 * • Copy-to-clipboard enhancements
 * • External link indicators
 * • Automatic anchor links
 * • Diagram interaction
 * • Keyboard shortcuts
 * • Documentation analytics
 * • Search enhancements
 * • Theme customizations
 *
 ******************************************************************************/

"use strict";

/* =============================================================================
 * BAOBAB Documentation
 * =============================================================================
 */

(() => {

    /**
     * Whether the visitor has requested reduced motion at the OS level.
     *
     * Checked live rather than cached at module load: document$ fires on
     * every instant-navigation transition, and re-checking is negligible
     * cost compared to correctness.
     */
    function prefersReducedMotion() {

        return window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    }

    /**
     * Landing page hero entrance.
     *
     * Adds the .slide-up class (animations.css) to the landing page's hero
     * content once per page view. Scoped to .landing-hero .hero-content, so
     * this is a no-op on every page other than docs/index.md.
     */
    function initialiseHero() {

        const hero = document.querySelector(".landing-hero .hero-content");

        if (!hero || prefersReducedMotion()) {
            return;
        }

        hero.classList.add("slide-up");

    }

    /**
     * Landing page scroll-triggered reveal.
     *
     * Adds the .fade-in class (animations.css) to landing-page card
     * elements as they enter the viewport, then stops observing each one —
     * this is a one-time entrance effect per page view, not a repeating
     * animation.
     *
     * Skipped entirely under prefers-reduced-motion. animations.css also
     * neutralises animation duration under that media query as a safety
     * net, but not attaching the class in the first place is the more
     * correct fix, per this file's own "Preserve accessibility" principle.
     */
    function initialiseRevealAnimations() {

        if (prefersReducedMotion()) {
            return;
        }

        const targets = document.querySelectorAll(
            ".feature-card, .tech-item, .documentation-card, .status-card, .showcase-panel"
        );

        if (targets.length === 0) {
            return;
        }

        const observer = new IntersectionObserver((entries, obs) => {

            entries.forEach((entry) => {

                if (entry.isIntersecting) {
                    entry.target.classList.add("fade-in");
                    obs.unobserve(entry.target);
                }

            });

        }, {
            threshold: 0.15,
        });

        targets.forEach((target) => observer.observe(target));

    }

    /**
     * Smooth in-page scrolling for anchor links (table-of-contents jumps,
     * permalinks).
     *
     * Guarded by prefers-reduced-motion at the source, rather than relying
     * solely on animations.css's `scroll-behavior: auto !important`
     * override to neutralise it after the fact — see that file's own note
     * explaining why both the JS guard and the CSS safety net matter.
     */
    function enableSmoothScrolling() {

        if (prefersReducedMotion()) {
            return;
        }

        document.documentElement.style.scrollBehavior = "smooth";

    }

    /**
     * Initialize custom documentation enhancements.
     *
     * Runs on the initial page load AND on every subsequent
     * navigation.instant transition — see the "Instant Navigation" note
     * above for why this can't be a plain DOMContentLoaded listener.
     */
    function initialise() {

        console.debug("BAOBAB documentation initialized.");

        initialiseHero();
        initialiseRevealAnimations();
        enableSmoothScrolling();

    }

    if (typeof document$ !== "undefined") {

        // Material's own observable — fires on initial load and on every
        // instant-navigation page swap.
        document$.subscribe(initialise);

    } else {

        // Defensive fallback only. Should not be reachable while
        // navigation.instant remains enabled in mkdocs.yml, since
        // document$ is exported by Material's own bundled JS and is
        // always present once the theme has loaded.
        document.addEventListener("DOMContentLoaded", initialise);

    }

})();