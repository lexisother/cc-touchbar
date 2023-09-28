const dir = modloader.installedMods.get('cc-touchbar').baseDirectory;
const addon = require(`${dir}build/Release/addon.node`);

window.addon = addon;
console.log(addon);
console.log(addon.hello());
addon.setTouchbar();
