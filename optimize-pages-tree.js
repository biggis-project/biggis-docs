#!/usr/bin/env node

const fs = require('fs')
const yaml = require('js-yaml')


function firstObjectKey(obj) {
  return Object.keys(obj)[0]
}

function firstObjectEntry(obj) {
  const firstKey = firstObjectKey(obj)
  return obj[firstKey]
}

function dfs(node) {
  if (node instanceof Array) {
    return node.map(x => dfs(x)) // go deeper
  }

  if (node instanceof Object) {
    const entry = firstObjectEntry(node)
    const key = firstObjectKey(node)

    if (entry instanceof Array) {
      if (entry.length === 1) {
        return entry[0] // transform
      } else {
        node[key] = dfs(entry) // go deeper
      }
    }
  }

  return node
}

const data = fs.readFileSync('/dev/stdin', 'utf8')
const yamldoc = yaml.safeLoad(data)
const newdoc = dfs(yamldoc)

console.log(yaml.safeDump(newdoc))
