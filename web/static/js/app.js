import "phoenix_html"
import Vue from 'vue'
import VueMaterial from 'vue-material'
import BlackSwan from "../components/black-swan.vue"

Vue.use(VueMaterial)
// Create the main component
Vue.component('black-swan', BlackSwan)

// And create the top-level view model:
new Vue({
  el: '#app',
  render(createElement) {
    return createElement(BlackSwan, {})
  }
});