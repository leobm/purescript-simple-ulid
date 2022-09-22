'use strict';

export async function prng() {
  var webCrypto = typeof window !== "undefined" && (window.crypto || window.msCrypto);
  if (webCrypto) {
    var buf = new Uint8Array(1);
    webCrypto.getRandomValues(buf);
    return buf[0] / 0xff;
  } else {
    const { randomBytes } = await import('crypto');
    return randomBytes(1).readUInt8() / 0xff;
  }
}
