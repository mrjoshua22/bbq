import Lightbox from "bs5-lightbox"

document.addEventListener("turbo:load", function () {
  document.querySelectorAll(".event-photo").forEach(
    el => el.addEventListener("click", Lightbox.initialize)
  );
})
