Vue.component('categories-list', {
  name: 'categories-list'

  components: { 'categories-list': this } # because of recursive use

  template: '<div v-if="categories.length > 0">\
  <select v-model="localselected" @change="onChange">\
  <option disabled value="">Please select one</option>\
  <option v-for="category in categories" :key="category.id" :value="category.id">{{ category.name }}</option>\
  </select>\
  <categories-list v-if="childExists" :parent="localselected" :depth="depth + 1" v-model="selected"></categories-list>
  </div>'


  model: {
    prop: 'selected',
    event: 'change'
  }


  props: {
    depth: {
      type: Number
      default: 0
    }
    parent: {
      validator: (value) -> value is null or value > 0
      default: -> null
    }
    selected: {
      type: Array
      default: []
    }
  }


  data: ->
    return {
      localselected: false
      categories: []
    }


  computed: {
    childExists: ->
      for c, i in window.categories
        if c.parents.indexOf(@localselected) > -1
          return true
      return false
  }


  created: ->
    @categories = window.categories.filter (c) => c.parents.indexOf(@parent) > -1  # use of fat arrow to maintain scope of "this"/@


  methods: {

    onChange: ->

      Vue.set(@selected, @depth, @localselected)

      min = @depth + 1
      max = @selected.length

      for i in [min..max]
        Vue.delete(@selected, i)

      this.$emit('change', @selected)

  }

})
