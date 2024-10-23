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

const initializeParsleyForms = () => {
  $('.parsley-form').each(function() {
    if ($(this).data('Parsley')) {
      $(this).parsley().destroy();
    }
    
    $(this).parsley({
      errorClass: 'is-invalid',
      successClass: 'is-valid',
      errorsWrapper: '<div class="invalid-feedback"></div>',
      errorTemplate: '<span></span>',
      trigger: 'change'
    });
  });
}

$(document).ready(initializeParsleyForms);
document.addEventListener("turbolinks:load", initializeParsleyForms);

$(document).on('submit', '.parsley-form', function(e) {
  const form = $(this);
  if (!form.parsley().isValid()) {
    e.preventDefault();
    e.stopPropagation();
    return false;
  }
});

$(document).on('keyup', '.parsley-form input', function() {
  $(this).parsley().validate();
});
