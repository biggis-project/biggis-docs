# List of Press Releases

<style>
th a * { float:right; color: white }
</style>
<div id="vueapp">
  <div v-if="Array.isArray(items)" class="animated fadeInRightShort go">
    <ul>
      <li v-for="item in items">
        <a v-if="item.link" href="{{item.link}}">{{item.title}},</a>
        <a v-if="item.pdf"  href="{{item.pdf}}">{{item.title}},</a>
        {{item.date}}
      </li>
    </ul>
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
    items_url: 'http://biggis-project.eu/data/press.json',
    items_edit_url: 'https://github.com/biggis-project/biggis-project.github.io/blob/master/data/press.json'
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
