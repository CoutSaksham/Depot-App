
// Configure your import map in config/importmap.rb.
// Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"
import "channels"

import "trix"
import "@rails/actiontext"

// Run JavaScript whenever a Turbo page loads
document.addEventListener("turbo:load", () => {

  // ----------------------------------
  // 1. Auto-dismiss flash messages
  // ----------------------------------

  const flashMessages = document.querySelectorAll(".flash");

  flashMessages.forEach((message) => {
    setTimeout(() => {
      message.style.transition = "opacity 0.5s ease";
      message.style.opacity = "0";

      setTimeout(() => {
        message.remove();
      }, 500);

    }, 3000);
  });


  // ----------------------------------
  // 2. Product image slider
  // ----------------------------------

  document.querySelectorAll("[data-slider]").forEach((slider) => {

    const slides = slider.querySelectorAll(".slide");
    const next = slider.querySelector("[data-next]");
    const prev = slider.querySelector("[data-prev]");

    // Don't initialize an empty slider
    if (slides.length === 0) return;

    let currentIndex = 0;

    // Display the selected image
    function showSlide(index) {

      slides[currentIndex].classList.remove("active");

      currentIndex = (index + slides.length) % slides.length;

      slides[currentIndex].classList.add("active");
    }

    // Next image
    if (next) {
      next.addEventListener("click", () => {
        showSlide(currentIndex + 1);
      });
    }

    // Previous image
    if (prev) {
      prev.addEventListener("click", () => {
        showSlide(currentIndex - 1);
      });
    }

  });

});
