# List of Presentations

<style>
th a * { float:right; color: white }
</style>
<div id="vueapp">
  <div v-if="Array.isArray(items)" class="animated fadeInRightShort go">
    <table>
      <tr>
        <th>Date</th>
        <th>Author(s)</th>
        <th colspan="2">
          Title / Link
          <a :href="items_edit_url" title="Edit source JSON">
            <i class="material-icons">mode_edit</i>
          </a>
        </th>
      </tr>
      <tr v-for="item in items">
        <td>{{item.date}}</td>
        <td>
          <span v-for="(author,author_idx) in ensureArray(item.authors)">
            {{author}}<span v-if="author_idx < item.authors.length-1">,</span>
          </span>
        </td>
        <td>
          <div v-if="item.title">{{item.title}}.</div>
          <div v-if="item.note">({{item.note}})</div>
        </td>
        <td>
          <a v-if="item.link" :href="item.link"><i class="material-icons">open_in_new</i></a>
          <a v-if="item.pdf" :href="item.pdf"><i class="material-icons">insert_drive_file</i></a>
        </td>
      </tr>
    </table>
  </div>
  <div v-else>Loading list ...</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue"></script>
<script src="../lib.js"></script>
<script>
const vueapp = new Vue({
  el: '#vueapp',
  data: {
    items: null,
    items_url: 'http://biggis-project.eu/data/presentations.json',
    items_edit_url: 'https://github.com/biggis-project/biggis-project.github.io/blob/master/data/presentations.json'
  },
  methods: {
    async loadItems() {
      const json = await fetch(this.items_url).then(response => response.json())
      this.items = json.sort(sortByDate)
    }
  }
})
vueapp.loadItems() // async load
</script>
