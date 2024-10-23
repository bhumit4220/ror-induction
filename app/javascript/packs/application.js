// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
import 'bootstrap';
import '@popperjs/core';
import "@fortawesome/fontawesome-free/js/all";
import "chartkick/chart.js"
import $ from 'jquery';
import 'parsleyjs';
// Expose jQuery globally
window.$ = $;
window.jQuery = $;

// Add this to your application.js after Parsley initialization
document.addEventListener("turbolinks:load", function() {
  $('form[data-parsley-validate]').on('submit', function(e) {
    const form = $(this);
    if (!form.parsley().isValid()) {
      e.preventDefault();
      return false;
    }
  });
});

