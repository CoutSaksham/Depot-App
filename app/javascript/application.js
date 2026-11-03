// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
document.addEventListener("turbo:load", () => {
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
});import "channels"

import "trix"
import "@rails/actiontext"
