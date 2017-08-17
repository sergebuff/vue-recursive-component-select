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
    prop: 'selected'
    event: 'change'
  }


  props: {
    depth: {
      type: Number
      default: 0
    }
    parent: {
      validator: (value) -> value is null or typeof value is "string"
      default: -> null
    }
    selected: {
      type: Array
      default: -> return []
    }
  }


  data: ->
    return {
      localselected: false
      categories: []
    }


  computed: {
    childExists: ->
      if @localselected.length > 1
        for c in window.categories
          return true if c.parents.indexOf(@localselected) >= 0
      return false
  }


  created: ->
    @categories = window.categories.filter (c) => # use of fat arrow to maintain scope of "this"/@
      return if @parent is null and c.parents.length < 1 then true else c.parents.indexOf(@parent) > -1



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
