export default class CCTouchBar {
  constructor(mod) {
    const addon =
      (window.CCTouchBarNative =
      this.addon =
        require(`${mod.baseDirectory}build/Release/addon.node`));

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
