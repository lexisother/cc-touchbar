// const dir = modloader.installedMods.get('nodeapi').baseDirectory;
// const addon = require(`${dir}build/Release/addon.node`);
const addon = require(`./build/Release/addon.node`);

window.addon = addon;
console.log(addon);
console.log(addon.hello());
addon.setTouchbar();
