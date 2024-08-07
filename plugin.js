const fs = window.require?.('fs');

export default class CCTouchBar {
  constructor(mod) {
    const debugPath = `${mod.baseDirectory}build/Debug/addon.node`;
    const releasePath = `${mod.baseDirectory}build/Release/addon.node`;
    const release = fs.existsSync(releasePath);

    const addon =
      (window.CCTouchBarNative =
      this.addon =
        require(release ? releasePath : debugPath));

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
