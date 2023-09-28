export default class CCTouchbar {
  constructor(mod) {
    const addon = require(`${mod.baseDirectory}build/Release/addon.node`);

    console.log(addon.hello());
    addon.setTouchbar();
  }
}
