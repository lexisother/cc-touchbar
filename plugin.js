export default class CCTouchbar {
  constructor(mod) {
    const addon = (this.addon = require(`${mod.baseDirectory}build/Release/addon.node`));

    console.log(addon.hello());
    addon.setTouchbar();
  }

  prestart() {
    const addon = this.addon;
    ig.ENTITY.Player.inject({
      initModel() {
        this.parent();
        addon.setButtonLabel(sc.model.player.config.name);
      },
    });
  }
}
