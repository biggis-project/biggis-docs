// newest items first
function sortByDate(a, b) {
  return new Date(b.date).getTime() - new Date(a.date).getTime()
}

function ensureArray(x) {
  return Array.isArray(x) ? x : [x]
}