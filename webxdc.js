window.webxdc = (() => {
  // We still have to store it, because it's called on sendUpdate too
  let updateListener = (update) => {};

  return {
    sendUpdateInterval: 10000,
    sendUpdateMaxSize: 128000,
    sendUpdate: (update) => {
      fetch('/cgi-bin/send-update.lua', {
        method: "POST",
        body: JSON.stringify({
          payload: update.payload,
          summary: update.summary,
          info: update.info,
          notify: update.notify,
          href: update.href,
          document: update.document,
        }),
      }).then(async (response) => {
        const serial = await response.json();
        update.serial = serial.serial;
        update.max_serial = serial.max_serial;
        updateListener(update);
      });
    },
    setUpdateListener: (listener, serial = 0) => {
      updateListener = listener;
      return fetch(`/cgi-bin/get-updates.lua?serial=${serial}`).then(async (response) => {
        const updates = await response.json();
        updates.forEach((update) => {
          updateListener(update);
        });
      });
    },
  };
})();
