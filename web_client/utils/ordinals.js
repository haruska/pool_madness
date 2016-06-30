// http://stackoverflow.com/questions/15998005/ordinals-in-words-javascript
export function ordinalInWord(cardinal) {
  let ordinals = ['Zeroth', 'First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh', 'Eighth', 'Ninth', 'Tenth']
  return ordinals[cardinal]
}
