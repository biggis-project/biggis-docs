# List of Github Repositories

<style>
th a * { float:right; color: white }
</style>
<div id="vueapp">
  <div v-if="Array.isArray(items)" class="animated fadeInRightShort go">
    <table>
      <tr><th>Name</th><th>Description</th></tr>
      <tr v-for="item in items.filter(x=>!x.private)">
        <td><a :href="item.html_url">{{item.name}}</a></td>
        <td>{{item.description}}</td>
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
    items_url: 'https://api.github.com/orgs/biggis-project/repos',
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
