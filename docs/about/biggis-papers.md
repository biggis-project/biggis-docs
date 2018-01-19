# List of Papers

<div id="vueapp">
  <table>
    <tr>
      <th>Date</th>
      <th>Author(s)</th>
      <th colspan="2">
        Title / Link
        <a style="float:right" :href="papers_edit_url" title="Edit source JSON">
          <i class="material-icons">mode_edit</i>
        </a>
      </th>
    </tr>
    <tr v-for="paper in papers">
      <td>{{paper.date}}</td>
      <td>
        <span v-for="(author,author_idx) in paper.authors">
          {{author}}<span v-if="author_idx < paper.authors.length-1">,</span>
        </span>
      </td>
      <td>
        <div v-if="paper.title">{{paper.title}}.</div>
        <div v-if="paper.note">({{paper.note}})</div>
        <div v-if="paper.event" style="padding-top:7px">
          {{paper.event.title}},
          {{paper.event.place}},
          {{paper.event.info}}
        </div>
      </td>
      <td>
        <a v-if="paper.link" :href="paper.link"><i class="material-icons">open_in_new</i></a>
        <a v-if="paper.pdf" :href="paper.pdf"><i class="material-icons">insert_drive_file</i></a>
        <a v-if="paper.event && paper.event.url" :href="paper.event.url"><i class="material-icons">open_in_new</i></a>
      </td>
    </tr>
  </table>
<div>

<script src="https://cdn.jsdelivr.net/npm/vue"></script>
<script src="../lib.js"></script>
<script>
const vueapp = new Vue({
  el: '#vueapp',
  data: {
    papers: 'Loading papers ...',
    papers_url: 'http://biggis-project.eu/data/papers.json',
    papers_edit_url: 'https://github.com/biggis-project/biggis-project.github.io/blob/master/data/papers.json'
  },
  methods: {
    async loadPapers() {
      const json = await fetch(this.papers_url).then(response=>response.json())
      this.papers = json.sort(sortByDate)
    }
  }
})
vueapp.loadPapers() // async load
</script>
