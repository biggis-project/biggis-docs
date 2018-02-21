# List of Github Repositories

<div id="vueapp" style="display:none">
  <v-app>
    <v-toolbar dense dark color="blue darken-2">
      <v-toolbar-side-icon disabled></v-toolbar-side-icon>
      <span v-text="toolbarStatus"></span>
      <v-spacer></v-spacer>
      <v-btn icon :href="items_edit_url">
        <v-icon>edit</v-icon>
      </v-btn>
    </v-toolbar>
    <v-container fluid grid-list-lg v-if="isLoaded" class="animated fadeInDownShort go">
      <v-layout row wrap>
        <v-flex xs12 v-for="(item, index) in publicItems" :key="index">
          <v-card>
            <v-card-title primary-title class="title">
              {{ item.name }}
            </v-card-title>
            <v-card-text class="teal--text comma-list">
              {{ item.description }}
            </v-card-text>
            <v-card-text class="grey--text">
              {{ item.note }}
            </v-card-text>
            <v-card-actions>
              <v-chip disabled outline color="grey">{{ item.created_at }}</v-chip>
              <v-chip v-if="item.archived" disabled color="red" text-color="white">archived</v-chip>
              <v-spacer></v-spacer>
              <v-btn dark :href="item.html_url">
                Open
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>
  </v-app>
</div>

<div>
<link href="https://unpkg.com/vuetify/dist/vuetify.min.css" rel="stylesheet"></link>
<style>
th a * { float:right; color: white }
.md-header a, .md-tabs a {color: white}
html { font-size: 62.5%; } /* mkdocs vs vuetify fix */
.comma-list > span:not(:last-child):after {
  content: ", ";
}
</style>
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<script src="https://unpkg.com/vuetify/dist/vuetify.js"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script src="../lib.js"></script>
<script>
const vueapp = new Vue({
  el: '#vueapp',
  data: {
    items: null,
    items_url: 'https://api.github.com/orgs/biggis-project/repos',
    items_edit_url: 'https://github.com/biggis-project'
  },
  computed:{
    isLoaded() {
      return Array.isArray(this.items);
    },
    toolbarStatus() {
      if(this.isLoaded) return ''
      if(this.items == null) return 'Loading ...'
      return this.items
    },
    publicItems() {
      return this.items.filter(x=>!x.private)
    }
  },
  methods: {
    async loadItems() {
      const json = await fetch(this.items_url).then(function(resp) { return resp.json()} );
      this.items = json.sort(sortByDate);
      try {
        const resp = await axios(this.items_url)
        this.items = resp.data.sort(sortByDate)
      } catch(e) {
        this.items = e.response.data.message
      }
    }
  }
});
vueapp.loadItems() // async load
vueapp.$el.style.display = 'block' // hack because html shows before vue init
</script>
</div>
