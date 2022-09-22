'use strict';

import * as nodeCrypto from "crypto";

export function prng() {
  var webCrypto = typeof window !== "undefined" && (window.crypto || window.msCrypto);
  if (webCrypto) {
    var buf = new Uint8Array(1);
    webCrypto.getRandomValues(buf);
    return buf[0] / 0xff;
  } else {
    return nodeCrypto.randomBytes(1).readUInt8() / 0xff;
  }
}
