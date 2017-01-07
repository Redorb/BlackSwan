import "phoenix_html"
import Vue from 'vue'
import BlackSwan from "../components/black-swan.vue"

// Create the main component
Vue.component('black-swan', BlackSwan)

// And create the top-level view model:
new Vue({
  el: '#app',
  render(createElement) {
    return createElement(BlackSwan, {})
  }
});