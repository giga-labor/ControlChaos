document.addEventListener('DOMContentLoaded', () => {
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
