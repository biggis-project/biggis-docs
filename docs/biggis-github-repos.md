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
  <div v-else>{{items}}</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script src="../lib.js"></script>
<script>
const vueapp = new Vue({
  el: '#vueapp',
  data: {
    items: 'Loading list ...',
    items_url: 'https://api.github.com/orgs/biggis-project/repos',
  },
  methods: {
    async loadItems() {
      try {
        const resp = await axios(this.items_url)
        this.items = resp.data.sort(sortByDate)
      } catch(e) {
        this.items = e.response.data.message
      }
    }
  }
})
vueapp.loadItems() // async load
</script>
