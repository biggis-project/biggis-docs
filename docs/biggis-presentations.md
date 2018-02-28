# List of Presentations

<div id="vueapp" style="display:none">
  <v-app>
    <v-toolbar dense dark color="blue darken-2">
      <v-toolbar-side-icon disabled></v-toolbar-side-icon>
      <span v-text="toolbarStatus"></span>
      <v-spacer></v-spacer>
      <v-btn icon :href="items_url">
        <v-icon>file_download</v-icon>
      </v-btn>
      <v-btn icon :href="items_edit_url">
        <v-icon>edit</v-icon>
      </v-btn>
    </v-toolbar>
    <v-container fluid grid-list-lg v-if="isLoaded" class="animated fadeInDownShort go">
      <v-layout row wrap>
        <v-flex xs12 v-for="(item, index) in items" :key="index">
          <v-card>
            <v-card-title primary-title class="title">
              {{ item.title }}
            </v-card-title>
            <v-card-text class="teal--text comma-list">
              <span v-for="(author, author_idx) in ensureArray(item.authors)">{{author}}</span>
            </v-card-text>
            <v-card-text class="grey--text">
              {{ item.note }}
              <div v-if="item.event">
                {{ eventData(item) }}
              </div>
            </v-card-text>
            <v-card-actions>
              <v-chip outline color="grey">{{ item.date }}</v-chip>
              <v-spacer></v-spacer>
              <v-btn icon v-if="item.link" :href="item.link">
                <v-icon color="blue darken-2">open_in_new</v-icon>
              </v-btn>
              <v-btn icon v-if="item.pdf" :href="item.pdf">
                <v-icon color="blue darken-2">insert_drive_file</v-icon>
              </v-btn>
              <v-btn icon v-if="item.event && item.event.url" :href="item.event.url">
                <v-icon color="blue darken-2">open_in_browser</v-icon>
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
.md-header a, .md-tabs a, .md-footer a {color: white}
.md-sidebar a {color:black}
html { font-size: 62.5%; } /* mkdocs vs vuetify fix */
.comma-list > span:not(:last-child):after {
  content: ", ";
}
</style>
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<script src="https://unpkg.com/vuetify/dist/vuetify.js"></script>
<script src="../lib.js"></script>
<script>
const vueapp = new Vue({
  el: '#vueapp',
  data: {
    items: null,
    items_url: 'http://biggis-project.eu/data/presentations.json',
    items_edit_url: 'https://github.com/biggis-project/biggis-project.github.io/blob/master/data/presentations.json'
  },
  computed:{
    isLoaded() {
      return Array.isArray(this.items);
    },
    toolbarStatus() {
      return this.isLoaded ? '' : 'Loading ...';
    }
  },
  methods: {
    async loadItems() {
      const json = await fetch(this.items_url).then(function(resp) { return resp.json()} );
      this.items = json.sort(sortByDate);
    },
    ensureArray(x) {
      return Array.isArray(x) ? x : [x]
    },
    eventData(item) {
      return [
        item.event.title,
        item.event.place,
        item.event.info
      ].filter(x => x).join(", ")
    }
  }
});
vueapp.loadItems() // async load
vueapp.$el.style.display = 'block' // hack because html shows before vue init
</script>
</div>