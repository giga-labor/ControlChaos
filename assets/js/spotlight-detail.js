document.addEventListener('DOMContentLoaded', () => {
  if (window.CARDS && typeof window.CARDS.enableDepth === 'function') {
    window.CARDS.enableDepth(document);
  }
  bindSpotlightHeroFallbackDepth();
  const layouts = document.querySelectorAll('[data-spotlight-layout]');
  layouts.forEach((layout) => initSpotlightLayout(layout));
});

function initSpotlightLayout(layout) {
  const card = layout.querySelector('[data-spotlight-card]');
  if (!card) return;

  const activate = () => {
    layout.classList.add('is-selected');
  };

  card.addEventListener('click', activate);
  card.addEventListener('keydown', (event) => {
    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault();
      activate();
    }
  });
}

function bindSpotlightHeroFallbackDepth() {
  const heroes = document.querySelectorAll('[data-spotlight-hero-card]');
  heroes.forEach((card) => {
    // Always bind a dedicated spotlight glow handler: this guarantees mouse-light effects
    // even when global depth binding is absent or overridden by page-specific styles.
    if (card.dataset.heroDepthBound === '1') return;
    card.dataset.heroDepthBound = '1';

    const reset = () => {
      card.style.setProperty('--card-rotate-x', '0deg');
      card.style.setProperty('--card-rotate-y', '0deg');
      card.style.setProperty('--card-glow-x', '50%');
      card.style.setProperty('--card-glow-y', '12%');
      card.style.setProperty('--spotlight-glow-x', '50%');
      card.style.setProperty('--spotlight-glow-y', '18%');
      card.style.setProperty('--card-lift', '0px');
      card.style.setProperty('--card-z', '0px');
      card.style.setProperty('--edge-left-a', '0.18');
      card.style.setProperty('--edge-right-a', '0.18');
      card.style.setProperty('--edge-top-a', '0.24');
      card.style.setProperty('--edge-bottom-a', '0.24');
      card.style.setProperty('--edge-spread', '7%');
      card.style.setProperty('--edge-spread-top', '7%');
      card.style.setProperty('--edge-spread-bottom', '8%');
    };

    const onMove = (event) => {
      const rect = card.getBoundingClientRect();
      if (!rect.width || !rect.height) return;
      const x = Math.min(Math.max((event.clientX - rect.left) / rect.width, 0), 1);
      const y = Math.min(Math.max((event.clientY - rect.top) / rect.height, 0), 1);
      const dx = x * 2 - 1;
      const dy = y * 2 - 1;

      card.style.setProperty('--card-glow-x', `${(x * 100).toFixed(1)}%`);
      card.style.setProperty('--card-glow-y', `${(y * 100).toFixed(1)}%`);
      card.style.setProperty('--spotlight-glow-x', `${(x * 100).toFixed(1)}%`);
      card.style.setProperty('--spotlight-glow-y', `${(y * 100).toFixed(1)}%`);
      card.style.setProperty('--card-rotate-x', `${(-6 * dy).toFixed(2)}deg`);
      card.style.setProperty('--card-rotate-y', `${(8 * dx).toFixed(2)}deg`);
      card.style.setProperty('--edge-left-a', (0.14 + Math.max(0, -dx) * 0.26).toFixed(3));
      card.style.setProperty('--edge-right-a', (0.14 + Math.max(0, dx) * 0.26).toFixed(3));
      card.style.setProperty('--edge-top-a', (0.16 + Math.max(0, -dy) * 0.24).toFixed(3));
      card.style.setProperty('--edge-bottom-a', (0.16 + Math.max(0, dy) * 0.24).toFixed(3));
      card.classList.add('is-hovered');
    };

    const onEnter = () => {
      card.classList.add('is-hovered');
      card.style.setProperty('--card-lift', '-8px');
      card.style.setProperty('--card-z', '10px');
    };

    const onLeave = () => {
      card.classList.remove('is-hovered');
      reset();
    };

    card.addEventListener('pointerenter', onEnter);
    card.addEventListener('pointermove', onMove);
    card.addEventListener('pointerleave', onLeave);
    card.addEventListener('pointercancel', onLeave);
    card.addEventListener('mouseenter', onEnter);
    card.addEventListener('mouseleave', onLeave);

    reset();
  });
}
