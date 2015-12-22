(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function (Buffer){

var utils = require('./lib/utils')

/**
 * Parses and returns the client type and version of a bittorrent peer id.
 * Throws an exception if the peer id is invalid.
 *
 * @param {Buffer|string} peerId (as Buffer or hex/utf8 string)
 */
module.exports = function (peerId) {
  var buffer

  if (Buffer.isBuffer(peerId)) {
    buffer = peerId
    peerId = peerId.toString('utf8')
  } else if (typeof peerId === 'string') {
    buffer = new Buffer(peerId, 'utf8')

    // assume utf8 peerId, but if that's invalid, then try hex encoding
    if (buffer.length !== 20)
      buffer = new Buffer(peerId, 'hex')
  } else {
    throw new Error('Invalid peerId must be Buffer or hex string: ' + peerId)
  }

  if (buffer.length !== 20) {
    throw new Error('Invalid peerId length (hex buffer must be 20 bytes): ' + peerId)
  }

  // overwrite original peerId string with guaranteed utf8 version
  peerId = buffer.toString('utf8')

  var UNKNOWN = 'unknown'
  var FAKE = 'fake'
  var client = null
  var version
  var data

  // If the client reuses parts of the peer ID of other peers, then try to determine this
  // first (before we misidentify the client).
  if (utils.isPossibleSpoofClient(peerId)) {
    if ((client = utils.decodeBitSpiritClient(peerId, buffer))) return client
    if ((client = utils.decodeBitCometClient(peerId, buffer))) return client
    return { client: "BitSpirit?" }
  }

  // See if the client uses Az style identification
  if (utils.isAzStyle(peerId)) {
    if ((client = getAzStyleClientName(peerId))) {
      version = getAzStyleClientVersion(client, peerId)

      // Hack for fake ZipTorrent clients - there seems to be some clients
      // which use the same identifier, but they aren't valid ZipTorrent clients
      if (client.startsWith("ZipTorrent") && peerId.startsWith("bLAde", 8)) {
        return {
          client: UNKNOWN + " [" + FAKE  + ": " + name + "]",
          version: version
        }
      }

      // BitTorrent 6.0 Beta currently misidentifies itself
      if ("\u00B5Torrent" === client && "6.0 Beta" === version) {
        return {
          client: "Mainline",
          version: "6.0 Beta"
        }
      }

      // If it's the rakshasa libtorrent, then it's probably rTorrent
      if (client.startsWith("libTorrent (Rakshasa)")) {
        return {
          client: client + " / rTorrent*",
          version: version
        }
      }

      return {
        client: client,
        version: version
      }
    }
  }

  // See if the client uses Shadow style identification
  if (utils.isShadowStyle(peerId)) {
    if ((client = getShadowStyleClientName(peerId))) {
      // TODO: handle shadow style client version numbers
      return { client: client }
    }
  }

  // See if the client uses Mainline style identification
  if (utils.isMainlineStyle(peerId)) {
    if ((client = getMainlineStyleClientName(peerId))) {
      // TODO: handle mainline style client version numbers
      return { client: client }
    }
  }

  // Check for BitSpirit / BitComet disregarding from spoof mode
  if ((client = utils.decodeBitSpiritClient(peerId, buffer))) return client
  if ((client = utils.decodeBitCometClient(peerId, buffer))) return client

  // See if the client identifies itself using a particular substring
  if ((data = getSimpleClient(peerId))) {
    client = data.client

    // TODO: handle simple client version numbers
    return {
      client: client,
      version: data.version
    }
  }

  // See if client is a known to be awkward
  if ((client = utils.identifyAwkwardClient(peerId, buffer))) {
    return client
  }

  // TODO: handle unknown az-formatted and shadow-formatted clients
  return { client: "unknown" }
}

// Az style two byte code identifiers to real client name
var azStyleClients = {}
var azStyleClientVersions = {}

// Shadow's style one byte code identifiers to real client name
var shadowStyleClients = {}
var shadowStyleClientVersions = {}

// Mainline's new style uses one byte code identifiers too
var mainlineStyleClients = {}

// Clients with completely custom naming schemes
var customStyleClients = []

var VER_AZ_THREE_DIGITS = "1.2.3"
var VER_AZ_THREE_DIGITS_PLUS_MNEMONIC = "1.2.3 [4]"
var VER_AZ_FOUR_DIGITS = "1.2.3.4"
var VER_AZ_TWO_MAJ_TWO_MIN = "12.34"
var VER_AZ_SKIP_FIRST_ONE_MAJ_TWO_MIN = "2.34"
var VER_AZ_KTORRENT_STYLE = "1.2.3=[RD].4"
var VER_AZ_TRANSMISSION_STYLE = "transmission"
var VER_AZ_THREE_ALPHANUMERIC_DIGITS = "2.33.4"
var NO_VERSION = "NO_VERSION"

function addAzStyle (id, client, version) {
  version = version || VER_AZ_FOUR_DIGITS
  azStyleClients[id] = client
  azStyleClientVersions[client] = version
}

function addShadowStyle (id, client, version) {
  version = version || VER_AZ_THREE_DIGITS
  shadowStyleClients[id] = client
  shadowStyleClientVersions[client] = version
}

function addMainlineStyle (id, client) {
  mainlineStyleClients[id] = client
}

function addSimpleClient (client, version, id, position) {
  if (typeof id === 'number' || typeof id === 'undefined') {
    position = id
    id = version
    version = undefined
  }

  customStyleClients.push({
    id: id,
    client: client,
    version: version,
    position: position || 0
  })
}

function getAzStyleClientName (peerId) {
  return azStyleClients[peerId.substring(1, 3)]
}

function getShadowStyleClientName (peerId) {
  return shadowStyleClients[peerId.substring(0, 1)]
}

function getMainlineStyleClientName (peerId) {
  return mainlineStyleClients[peerId.substring(0, 1)]
}

function getSimpleClient (peerId) {
  for (var i = 0; i < customStyleClients.length; ++i) {
    var client = customStyleClients[i]

    if (peerId.startsWith(client.id, client.position)) {
      return client
    }
  }

  return null
}

function getAzStyleClientVersion (client, peerId) {
  var version = azStyleClientVersions[client]
  if (!version) return null

  return utils.getAzStyleVersionNumber(peerId.substring(3, 7), version)
}

(function () {
  // add known clients alphabetically
  addAzStyle("A~", "Ares", VER_AZ_THREE_DIGITS)
  addAzStyle("AG", "Ares", VER_AZ_THREE_DIGITS)
  addAzStyle("AN", "Ares", VER_AZ_FOUR_DIGITS)
  addAzStyle("AR", "Ares") // Ares is more likely than ArcticTorrent
  addAzStyle("AV", "Avicora")
  addAzStyle("AX", "BitPump", VER_AZ_TWO_MAJ_TWO_MIN)
  addAzStyle("AT", "Artemis")
  addAzStyle("AZ", "Vuze", VER_AZ_FOUR_DIGITS)
  addAzStyle("BB", "BitBuddy", "1.234")
  addAzStyle("BC", "BitComet", VER_AZ_SKIP_FIRST_ONE_MAJ_TWO_MIN)
  addAzStyle("BE", "BitTorrent SDK")
  addAzStyle("BF", "BitFlu", NO_VERSION)
  addAzStyle("BG", "BTG", VER_AZ_FOUR_DIGITS)
  addAzStyle("bk", "BitKitten (libtorrent)")
  addAzStyle("BR", "BitRocket", "1.2(34)")
  addAzStyle("BS", "BTSlave")
  addAzStyle("BW", "BitWombat")
  addAzStyle("BX", "BittorrentX")
  addAzStyle("CB", "Shareaza Plus")
  addAzStyle("CD", "Enhanced CTorrent", VER_AZ_TWO_MAJ_TWO_MIN)
  addAzStyle("CT", "CTorrent", "1.2.34")
  addAzStyle("DP", "Propogate Data Client")
  addAzStyle("DE", "Deluge", VER_AZ_FOUR_DIGITS)
  addAzStyle("EB", "EBit")
  addAzStyle("ES", "Electric Sheep", VER_AZ_THREE_DIGITS)
  addAzStyle("FC", "FileCroc")
  addAzStyle("FG", "FlashGet", VER_AZ_SKIP_FIRST_ONE_MAJ_TWO_MIN)
  addAzStyle("FT", "FoxTorrent/RedSwoosh")
  addAzStyle("GR", "GetRight", "1.2")
  addAzStyle("GS", "GSTorrent") // TODO: Format is v"abcd"
  addAzStyle("HL", "Halite", VER_AZ_THREE_DIGITS)
  addAzStyle("HN", "Hydranode")
  addAzStyle("KG", "KGet")
  addAzStyle("KT", "KTorrent", VER_AZ_KTORRENT_STYLE)
  addAzStyle("LC", "LeechCraft")
  addAzStyle("LH", "LH-ABC")
  addAzStyle("LK", "linkage", VER_AZ_THREE_DIGITS)
  addAzStyle("LP", "Lphant", VER_AZ_TWO_MAJ_TWO_MIN)
  addAzStyle("LT", "libtorrent (Rasterbar)", VER_AZ_THREE_ALPHANUMERIC_DIGITS)
  addAzStyle("lt", "libTorrent (Rakshasa)", VER_AZ_THREE_ALPHANUMERIC_DIGITS)
  addAzStyle("LW", "LimeWire", NO_VERSION) // The "0001" bytes found after the LW commonly refers to the version of the BT protocol implemented. Documented here: http://www.limewire.org/wiki/index.php?title=BitTorrentRevision
  addAzStyle("MO", "MonoTorrent")
  addAzStyle("MP", "MooPolice", VER_AZ_THREE_DIGITS)
  addAzStyle("MR", "Miro")
  addAzStyle("MT", "MoonlightTorrent")
  addAzStyle("NE", "BT Next Evolution", VER_AZ_THREE_DIGITS)
  addAzStyle("NX", "Net Transport")
  addAzStyle("OS", "OneSwarm", VER_AZ_FOUR_DIGITS)
  addAzStyle("OT", "OmegaTorrent")
  addAzStyle("PC", "CacheLogic", "12.3-4" )
  addAzStyle("PD", "Pando")
  addAzStyle("PE", "PeerProject")
  addAzStyle("pX", "pHoeniX")
  addAzStyle("qB", "qBittorrent", VER_AZ_THREE_DIGITS)
  addAzStyle("QD", "qqdownload")
  addAzStyle("RT", "Retriever")
  addAzStyle("RZ", "RezTorrent")
  addAzStyle("S~", "Shareaza alpha/beta")
  addAzStyle("SB", "SwiftBit")
  addAzStyle("SD", "\u8FC5\u96F7\u5728\u7EBF (Xunlei)") // Apparently, the English name of the client is "Thunderbolt".
  addAzStyle("SG", "GS Torrent", VER_AZ_FOUR_DIGITS)
  addAzStyle("SN", "ShareNET")
  addAzStyle("SP", "BitSpirit") // >= 3.6
  addAzStyle("SS", "SwarmScope")
  addAzStyle("ST", "SymTorrent", "2.34")
  addAzStyle("st", "SharkTorrent")
  addAzStyle("SZ", "Shareaza")
  addAzStyle("TN", "Torrent.NET")
  addAzStyle("TR", "Transmission", VER_AZ_TRANSMISSION_STYLE)
  addAzStyle("TS", "TorrentStorm")
  addAzStyle("TT", "TuoTu", VER_AZ_THREE_DIGITS)
  addAzStyle("UL", "uLeecher!")
  addAzStyle("UT", "\u00B5Torrent", VER_AZ_THREE_DIGITS_PLUS_MNEMONIC)
  addAzStyle("UM", "\u00B5Torrent Mac", VER_AZ_THREE_DIGITS_PLUS_MNEMONIC)
  addAzStyle("WT", "Bitlet")
  addAzStyle("WW", "WebTorrent") // Go Webtorrent!! :)
  addAzStyle("WY", "FireTorrent") // formerly Wyzo.
  addAzStyle("VG", "\u54c7\u560E (Vagaa)", VER_AZ_FOUR_DIGITS)
  addAzStyle("XL", "\u8FC5\u96F7\u5728\u7EBF (Xunlei)") // Apparently, the English name of the client is "Thunderbolt".
  addAzStyle("XT", "XanTorrent")
  addAzStyle("XX", "XTorrent", "1.2.34")
  addAzStyle("XC", "XTorrent", "1.2.34")
  addAzStyle("ZT", "ZipTorrent")
  addAzStyle("7T", "aTorrent")
  addAzStyle("#@", "Invalid PeerID")

  addShadowStyle('A', "ABC")
  addShadowStyle('O', "Osprey Permaseed")
  addShadowStyle('Q', "BTQueue")
  addShadowStyle('R', "Tribler")
  addShadowStyle('S', "Shad0w")
  addShadowStyle('T', "BitTornado")
  addShadowStyle('U', "UPnP NAT")

  addMainlineStyle('M', "Mainline")
  addMainlineStyle('Q', "Queen Bee")

  // Simple clients with no version number.
  addSimpleClient("\u00B5Torrent", "1.7.0 RC", "-UT170-") // http://forum.utorrent.com/viewtopic.php?pid=260927#p260927
  addSimpleClient("Azureus", "1", "Azureus")
  addSimpleClient("Azureus", "2.0.3.2", "Azureus", 5)
  addSimpleClient("Aria", "2", "-aria2-")
  addSimpleClient("BitTorrent Plus!", "II", "PRC.P---")
  addSimpleClient("BitTorrent Plus!", "P87.P---")
  addSimpleClient("BitTorrent Plus!", "S587Plus")
  addSimpleClient("BitTyrant (Azureus Mod)", "AZ2500BT")
  addSimpleClient("Blizzard Downloader", "BLZ")
  addSimpleClient("BTGetit", "BG", 10)
  addSimpleClient("BTugaXP", "btuga")
  addSimpleClient("BTugaXP", "BTuga", 5)
  addSimpleClient("BTugaXP", "oernu")
  addSimpleClient("Deadman Walking", "BTDWV-")
  addSimpleClient("Deadman", "Deadman Walking-")
  addSimpleClient("External Webseed", "Ext")
  addSimpleClient("G3 Torrent", "-G3")
  addSimpleClient("GreedBT", "2.7.1", "271-")
  addSimpleClient("Hurricane Electric", "arclight")
  addSimpleClient("HTTP Seed", "-WS" )
  addSimpleClient("JVtorrent", "10-------")
  addSimpleClient("Limewire", "LIME")
  addSimpleClient("Martini Man", "martini")
  addSimpleClient("Pando", "Pando")
  addSimpleClient("PeerApp", "PEERAPP")
  addSimpleClient("SimpleBT", "btfans", 4)
  addSimpleClient("Swarmy", "a00---0")
  addSimpleClient("Swarmy", "a02---0")
  addSimpleClient("Teeweety", "T00---0")
  addSimpleClient("TorrentTopia", "346-")
  addSimpleClient("XanTorrent", "DansClient")
  addSimpleClient("MediaGet", "-MG1")
  addSimpleClient("MediaGet", "2.1", "-MG21")

  /**
   * This is interesting - it uses Mainline style, except uses two characters instead of one.
   * And then - the particular numbering style it uses would actually break the way we decode
   * version numbers (our code is too hardcoded to "-x-y-z--" style version numbers).
   *
   * This should really be declared as a Mainline style peer ID, but I would have to
   * make my code more generic. Not a bad thing - just something I'm not doing right
   * now.
   */
  addSimpleClient("Amazon AWS S3", "S3-")

  // Simple clients with custom version schemes
  // TODO: support custom version schemes
  addSimpleClient("BitTorrent DNA", "DNA")
  addSimpleClient("Opera", "OP") // Pre build 10000 versions
  addSimpleClient("Opera", "O") // Post build 10000 versions
  addSimpleClient("Burst!", "Mbrst")
  addSimpleClient("TurboBT", "turbobt")
  addSimpleClient("BT Protocol Daemon", "btpd")
  addSimpleClient("Plus!", "Plus")
  addSimpleClient("XBT", "XBT")
  addSimpleClient("BitsOnWheels", "-BOW")
  addSimpleClient("eXeem", "eX")
  addSimpleClient("MLdonkey", "-ML")
  addSimpleClient("Bitlet", "BitLet")
  addSimpleClient("AllPeers", "AP")
  addSimpleClient("BTuga Revolution", "BTM")
  addSimpleClient("Rufus", "RS", 2)
  addSimpleClient("BitMagnet", "BM", 2) // BitMagnet - predecessor to Rufus
  addSimpleClient("QVOD", "QVOD")
  // Top-BT is based on BitTornado, but doesn't quite stick to Shadow's naming conventions,
  // so we'll use substring matching instead.
  addSimpleClient("Top-BT", "TB")
  addSimpleClient("Tixati", "TIX")
  // seems to have a sub-version encoded in following 3 bytes, not worked out how: "folx/1.0.456.591" : 2D 464C 3130 FF862D 486263574A43585F66314D5A
  addSimpleClient("folx", "-FL")
  addSimpleClient("\u00B5Torrent Mac", "-UM")
  addSimpleClient("\u00B5Torrent", "-UT") // UT 3.4+
})()


}).call(this,require("buffer").Buffer)
},{"./lib/utils":2,"buffer":4}],2:[function(require,module,exports){

if (typeof String.prototype.endsWith !== 'function') {
  String.prototype.endsWith = function (str){
    return this.slice(-str.length) === str
  }
}

if (typeof String.prototype.startsWith !== 'function') {
  String.prototype.startsWith = function (str, index) {
    index = index || 0
    return this.slice(index, index + str.length) === str
  }
}

module.exports = {
  isAzStyle: function (peerId) {
    if (peerId.charAt(0) !== '-') return false
    if (peerId.charAt(7) === '-') return true

    /**
     * Hack for FlashGet - it doesn't use the trailing dash.
     * Also, LH-ABC has strayed into "forgetting about the delimiter" territory.
     *
     * In fact, the code to generate a peer ID for LH-ABC is based on BitTornado's,
     * yet tries to give an Az style peer ID... oh dear.
     *
     * BT Next Evolution seems to be in the same boat as well.
     *
     * KTorrent 3 appears to use a dash rather than a final character.
     */
    if (peerId.substring(1, 3) === "FG") return true
    if (peerId.substring(1, 3) === "LH") return true
    if (peerId.substring(1, 3) === "NE") return true
    if (peerId.substring(1, 3) === "KT") return true
    if (peerId.substring(1, 3) === "SP") return true

    return false
  },

  /**
   * Checking whether a peer ID is Shadow style or not is a bit tricky.
   *
   * The BitTornado peer ID convention code is explained here:
   *   http://forums.degreez.net/viewtopic.php?t=7070
   *
   * The main thing we are interested in is the first six characters.
   * Although the other characters are base64 characters, there's no
   * guarantee that other clients which follow that style will follow
   * that convention (though the fact that some of these clients use
   * BitTornado in the core does blur the lines a bit between what is
   * "style" and what is just common across clients).
   *
   * So if we base it on the version number information, there's another
   * problem - there isn't the use of absolute delimiters (no fixed dash
   * character, for example).
   *
   * There are various things we can do to determine how likely the peer
   * ID is to be of that style, but for now, I'll keep it to a relatively
   * simple check.
   *
   * We'll assume that no client uses the fifth version digit, so we'll
   * expect a dash. We'll also assume that no client has reached version 10
   * yet, so we expect the first two characters to be "letter,digit".
   *
   * We've seen some clients which don't appear to contain any version
   * information, so we need to allow for that.
   */
  isShadowStyle: function(peerId) {
    if (peerId.charAt(5) !== '-') return false
    if (!isLetter(peerId.charAt(0))) return false
    if (!(isDigit(peerId.charAt(1)) || peerId.charAt(1) === '-')) return false

    // Find where the version number string ends.
    var lastVersionNumberIndex = 4
    for (; lastVersionNumberIndex > 0; lastVersionNumberIndex--) {
      if (peerId.charAt(lastVersionNumberIndex) !== '-') break
    }

    // For each digit in the version string, check if it is a valid version identifier.
    for (var i = 1; i <= lastVersionNumberIndex; i++) {
      var c = peerId.charAt(i)
      if (c === '-') return false
      if (isAlphaNumeric(c) === null) return false
    }

    return true
  },

  isMainlineStyle: function (peerId) {
    /**
     * One of the following styles will be used:
     *   Mx-y-z--
     *   Mx-yy-z-
     */
    return peerId.charAt(2) === '-' && peerId.charAt(7) === '-' &&
      (peerId.charAt(4) === '-' || peerId.charAt(5) === '-')
  },

  isPossibleSpoofClient: function (peerId) {
    return peerId.endsWith('UDP0') || peerId.endsWith('HTTPBT')
  },

  decodeNumericValueOfByte: decodeNumericValueOfByte,

  getAzStyleVersionNumber: function (peerId, version) {
    // TODO
    return null
  },

  getShadowStyleVersionNumber: function (peerId) {
    // TODO
    return null
  },

  decodeBitSpiritClient: function (peerId, buffer) {
    if (peerId.substring(2, 4) !== 'BS') return null
    var version = '' + buffer[1]
    if (version === '0') version = 1

    return {
      client: "BitSpirit",
      version: version
    }
  },

  decodeBitCometClient: function (peerId, buffer) {
    var modName = ""
    if (peerId.startsWith("exbc")) modName = ""
    else if (peerId.startsWith("FUTB")) modName = "(Solidox Mod)"
    else if (peerId.startsWith("xUTB")) modName = "(Mod 2)"
    else return null

    var isBitlord = (peerId.substring(6, 10) === "LORD")

    // Older versions of BitLord are of the form x.yy, whereas new versions (1 and onwards),
    // are of the form x.y. BitComet is of the form x.yy
    var clientName = (isBitlord) ? "BitLord" : "BitComet"
    var majVersion = decodeNumericValueOfByte(buffer[4])
    var minVersionLength = (isBitlord && majVersion !== "0" ? 1 : 2)

    return {
      client: clientName + (modName ? " " + modName : ""),
      version: majVersion + "." + decodeNumericValueOfByte(buffer[5], minVersionLength)
    }
  },

  identifyAwkwardClient: function (peerId, buffer) {
    var firstNonZeroIndex = 20
    var i

    for (i = 0; i < 20; ++i) {
      if (buffer[i] > 0) {
        firstNonZeroIndex = i
        break
      }
    }

    // Shareaza check
    if (firstNonZeroIndex === 0) {
      var isShareaza = true
      for (i = 0; i < 16; ++i) {
        if (buffer[i] === 0) {
          isShareaza = false
          break
        }
      }

      if (isShareaza) {
        for (i = 16; i < 20; ++i) {
          if (buffer[i] !== (buffer[i % 16] ^ buffer[15 - (i % 16)])) {
            isShareaza = false
            break
          }
        }

        if (isShareaza) return { client: "Shareaza" }
      }
    }

    if (firstNonZeroIndex === 9 && buffer[9] === 3 && buffer[10] === 3 && buffer[11] === 3)
      return { client: "I2PSnark" }

    if (firstNonZeroIndex === 12 && buffer[12] === 97 && buffer[13] === 97)
      return { client: "Experimental", version: "3.2.1b2" }

    if (firstNonZeroIndex === 12 && buffer[12] === 0 && buffer[13] === 0)
      return { client: "Experimental", version: "3.1" }

    if (firstNonZeroIndex === 12)
      return { client: "Mainline" }

    return null
  }
}

//
// Private helper functions for the public utility functions
//

function isDigit (s) {
  var code = s.charCodeAt(0)
  return code >= '0'.charCodeAt(0) && code <= '9'.charCodeAt(0)
}

function isLetter (s) {
  var code = s.toLowerCase().charCodeAt(0)
  return code >= 'a'.charCodeAt(0) && code <= 'z'.charCodeAt(0)
}

function isAlphaNumeric (s) {
  return isDigit(s) || isLetter(s) || s === '.'
}

function decodeNumericValueOfByte (b, minDigits) {
  minDigits = minDigits || 0
  var result = '' + (b & 0xff)
  while (result.length < minDigits) { result = '0' + result }
  return result
}


},{}],3:[function(require,module,exports){
(function (Buffer){
var peerid = require('bittorrent-peerid')
window.format_peerid = function(str) {
  str = unescape(str);
  buffer = new Buffer(str, 'binary');
  return peerid(buffer);
}

}).call(this,require("buffer").Buffer)
},{"bittorrent-peerid":1,"buffer":4}],4:[function(require,module,exports){
/*!
 * The buffer module from node.js, for the browser.
 *
 * @author   Feross Aboukhadijeh <feross@feross.org> <http://feross.org>
 * @license  MIT
 */

var base64 = require('base64-js')
var ieee754 = require('ieee754')

exports.Buffer = Buffer
exports.SlowBuffer = Buffer
exports.INSPECT_MAX_BYTES = 50
Buffer.poolSize = 8192

/**
 * If `Buffer._useTypedArrays`:
 *   === true    Use Uint8Array implementation (fastest)
 *   === false   Use Object implementation (compatible down to IE6)
 */
Buffer._useTypedArrays = (function () {
  // Detect if browser supports Typed Arrays. Supported browsers are IE 10+, Firefox 4+,
  // Chrome 7+, Safari 5.1+, Opera 11.6+, iOS 4.2+. If the browser does not support adding
  // properties to `Uint8Array` instances, then that's the same as no `Uint8Array` support
  // because we need to be able to add all the node Buffer API methods. This is an issue
  // in Firefox 4-29. Now fixed: https://bugzilla.mozilla.org/show_bug.cgi?id=695438
  try {
    var buf = new ArrayBuffer(0)
    var arr = new Uint8Array(buf)
    arr.foo = function () { return 42 }
    return 42 === arr.foo() &&
        typeof arr.subarray === 'function' // Chrome 9-10 lack `subarray`
  } catch (e) {
    return false
  }
})()

/**
 * Class: Buffer
 * =============
 *
 * The Buffer constructor returns instances of `Uint8Array` that are augmented
 * with function properties for all the node `Buffer` API functions. We use
 * `Uint8Array` so that square bracket notation works as expected -- it returns
 * a single octet.
 *
 * By augmenting the instances, we can avoid modifying the `Uint8Array`
 * prototype.
 */
function Buffer (subject, encoding, noZero) {
  if (!(this instanceof Buffer))
    return new Buffer(subject, encoding, noZero)

  var type = typeof subject

  if (encoding === 'base64' && type === 'string') {
    subject = base64clean(subject)
  }

  // Find the length
  var length
  if (type === 'number')
    length = coerce(subject)
  else if (type === 'string')
    length = Buffer.byteLength(subject, encoding)
  else if (type === 'object')
    length = coerce(subject.length) // assume that object is array-like
  else
    throw new Error('First argument needs to be a number, array or string.')

  var buf
  if (Buffer._useTypedArrays) {
    // Preferred: Return an augmented `Uint8Array` instance for best performance
    buf = Buffer._augment(new Uint8Array(length))
  } else {
    // Fallback: Return THIS instance of Buffer (created by `new`)
    buf = this
    buf.length = length
    buf._isBuffer = true
  }

  var i
  if (Buffer._useTypedArrays && typeof subject.byteLength === 'number') {
    // Speed optimization -- use set if we're copying from a typed array
    buf._set(subject)
  } else if (isArrayish(subject)) {
    // Treat array-ish objects as a byte array
    if (Buffer.isBuffer(subject)) {
      for (i = 0; i < length; i++)
        buf[i] = subject.readUInt8(i)
    } else {
      for (i = 0; i < length; i++)
        buf[i] = ((subject[i] % 256) + 256) % 256
    }
  } else if (type === 'string') {
    buf.write(subject, 0, encoding)
  } else if (type === 'number' && !Buffer._useTypedArrays && !noZero) {
    for (i = 0; i < length; i++) {
      buf[i] = 0
    }
  }

  return buf
}

// STATIC METHODS
// ==============

Buffer.isEncoding = function (encoding) {
  switch (String(encoding).toLowerCase()) {
    case 'hex':
    case 'utf8':
    case 'utf-8':
    case 'ascii':
    case 'binary':
    case 'base64':
    case 'raw':
    case 'ucs2':
    case 'ucs-2':
    case 'utf16le':
    case 'utf-16le':
      return true
    default:
      return false
  }
}

Buffer.isBuffer = function (b) {
  return !!(b !== null && b !== undefined && b._isBuffer)
}

Buffer.byteLength = function (str, encoding) {
  var ret
  str = str.toString()
  switch (encoding || 'utf8') {
    case 'hex':
      ret = str.length / 2
      break
    case 'utf8':
    case 'utf-8':
      ret = utf8ToBytes(str).length
      break
    case 'ascii':
    case 'binary':
    case 'raw':
      ret = str.length
      break
    case 'base64':
      ret = base64ToBytes(str).length
      break
    case 'ucs2':
    case 'ucs-2':
    case 'utf16le':
    case 'utf-16le':
      ret = str.length * 2
      break
    default:
      throw new Error('Unknown encoding')
  }
  return ret
}

Buffer.concat = function (list, totalLength) {
  assert(isArray(list), 'Usage: Buffer.concat(list[, length])')

  if (list.length === 0) {
    return new Buffer(0)
  } else if (list.length === 1) {
    return list[0]
  }

  var i
  if (totalLength === undefined) {
    totalLength = 0
    for (i = 0; i < list.length; i++) {
      totalLength += list[i].length
    }
  }

  var buf = new Buffer(totalLength)
  var pos = 0
  for (i = 0; i < list.length; i++) {
    var item = list[i]
    item.copy(buf, pos)
    pos += item.length
  }
  return buf
}

Buffer.compare = function (a, b) {
  assert(Buffer.isBuffer(a) && Buffer.isBuffer(b), 'Arguments must be Buffers')
  var x = a.length
  var y = b.length
  for (var i = 0, len = Math.min(x, y); i < len && a[i] === b[i]; i++) {}
  if (i !== len) {
    x = a[i]
    y = b[i]
  }
  if (x < y) {
    return -1
  }
  if (y < x) {
    return 1
  }
  return 0
}

// BUFFER INSTANCE METHODS
// =======================

function hexWrite (buf, string, offset, length) {
  offset = Number(offset) || 0
  var remaining = buf.length - offset
  if (!length) {
    length = remaining
  } else {
    length = Number(length)
    if (length > remaining) {
      length = remaining
    }
  }

  // must be an even number of digits
  var strLen = string.length
  assert(strLen % 2 === 0, 'Invalid hex string')

  if (length > strLen / 2) {
    length = strLen / 2
  }
  for (var i = 0; i < length; i++) {
    var byte = parseInt(string.substr(i * 2, 2), 16)
    assert(!isNaN(byte), 'Invalid hex string')
    buf[offset + i] = byte
  }
  return i
}

function utf8Write (buf, string, offset, length) {
  var charsWritten = blitBuffer(utf8ToBytes(string), buf, offset, length)
  return charsWritten
}

function asciiWrite (buf, string, offset, length) {
  var charsWritten = blitBuffer(asciiToBytes(string), buf, offset, length)
  return charsWritten
}

function binaryWrite (buf, string, offset, length) {
  return asciiWrite(buf, string, offset, length)
}

function base64Write (buf, string, offset, length) {
  var charsWritten = blitBuffer(base64ToBytes(string), buf, offset, length)
  return charsWritten
}

function utf16leWrite (buf, string, offset, length) {
  var charsWritten = blitBuffer(utf16leToBytes(string), buf, offset, length)
  return charsWritten
}

Buffer.prototype.write = function (string, offset, length, encoding) {
  // Support both (string, offset, length, encoding)
  // and the legacy (string, encoding, offset, length)
  if (isFinite(offset)) {
    if (!isFinite(length)) {
      encoding = length
      length = undefined
    }
  } else {  // legacy
    var swap = encoding
    encoding = offset
    offset = length
    length = swap
  }

  offset = Number(offset) || 0
  var remaining = this.length - offset
  if (!length) {
    length = remaining
  } else {
    length = Number(length)
    if (length > remaining) {
      length = remaining
    }
  }
  encoding = String(encoding || 'utf8').toLowerCase()

  var ret
  switch (encoding) {
    case 'hex':
      ret = hexWrite(this, string, offset, length)
      break
    case 'utf8':
    case 'utf-8':
      ret = utf8Write(this, string, offset, length)
      break
    case 'ascii':
      ret = asciiWrite(this, string, offset, length)
      break
    case 'binary':
      ret = binaryWrite(this, string, offset, length)
      break
    case 'base64':
      ret = base64Write(this, string, offset, length)
      break
    case 'ucs2':
    case 'ucs-2':
    case 'utf16le':
    case 'utf-16le':
      ret = utf16leWrite(this, string, offset, length)
      break
    default:
      throw new Error('Unknown encoding')
  }
  return ret
}

Buffer.prototype.toString = function (encoding, start, end) {
  var self = this

  encoding = String(encoding || 'utf8').toLowerCase()
  start = Number(start) || 0
  end = (end === undefined) ? self.length : Number(end)

  // Fastpath empty strings
  if (end === start)
    return ''

  var ret
  switch (encoding) {
    case 'hex':
      ret = hexSlice(self, start, end)
      break
    case 'utf8':
    case 'utf-8':
      ret = utf8Slice(self, start, end)
      break
    case 'ascii':
      ret = asciiSlice(self, start, end)
      break
    case 'binary':
      ret = binarySlice(self, start, end)
      break
    case 'base64':
      ret = base64Slice(self, start, end)
      break
    case 'ucs2':
    case 'ucs-2':
    case 'utf16le':
    case 'utf-16le':
      ret = utf16leSlice(self, start, end)
      break
    default:
      throw new Error('Unknown encoding')
  }
  return ret
}

Buffer.prototype.toJSON = function () {
  return {
    type: 'Buffer',
    data: Array.prototype.slice.call(this._arr || this, 0)
  }
}

Buffer.prototype.equals = function (b) {
  assert(Buffer.isBuffer(b), 'Argument must be a Buffer')
  return Buffer.compare(this, b) === 0
}

Buffer.prototype.compare = function (b) {
  assert(Buffer.isBuffer(b), 'Argument must be a Buffer')
  return Buffer.compare(this, b)
}

// copy(targetBuffer, targetStart=0, sourceStart=0, sourceEnd=buffer.length)
Buffer.prototype.copy = function (target, target_start, start, end) {
  var source = this

  if (!start) start = 0
  if (!end && end !== 0) end = this.length
  if (!target_start) target_start = 0

  // Copy 0 bytes; we're done
  if (end === start) return
  if (target.length === 0 || source.length === 0) return

  // Fatal error conditions
  assert(end >= start, 'sourceEnd < sourceStart')
  assert(target_start >= 0 && target_start < target.length,
      'targetStart out of bounds')
  assert(start >= 0 && start < source.length, 'sourceStart out of bounds')
  assert(end >= 0 && end <= source.length, 'sourceEnd out of bounds')

  // Are we oob?
  if (end > this.length)
    end = this.length
  if (target.length - target_start < end - start)
    end = target.length - target_start + start

  var len = end - start

  if (len < 100 || !Buffer._useTypedArrays) {
    for (var i = 0; i < len; i++) {
      target[i + target_start] = this[i + start]
    }
  } else {
    target._set(this.subarray(start, start + len), target_start)
  }
}

function base64Slice (buf, start, end) {
  if (start === 0 && end === buf.length) {
    return base64.fromByteArray(buf)
  } else {
    return base64.fromByteArray(buf.slice(start, end))
  }
}

function utf8Slice (buf, start, end) {
  var res = ''
  var tmp = ''
  end = Math.min(buf.length, end)

  for (var i = start; i < end; i++) {
    if (buf[i] <= 0x7F) {
      res += decodeUtf8Char(tmp) + String.fromCharCode(buf[i])
      tmp = ''
    } else {
      tmp += '%' + buf[i].toString(16)
    }
  }

  return res + decodeUtf8Char(tmp)
}

function asciiSlice (buf, start, end) {
  var ret = ''
  end = Math.min(buf.length, end)

  for (var i = start; i < end; i++) {
    ret += String.fromCharCode(buf[i])
  }
  return ret
}

function binarySlice (buf, start, end) {
  return asciiSlice(buf, start, end)
}

function hexSlice (buf, start, end) {
  var len = buf.length

  if (!start || start < 0) start = 0
  if (!end || end < 0 || end > len) end = len

  var out = ''
  for (var i = start; i < end; i++) {
    out += toHex(buf[i])
  }
  return out
}

function utf16leSlice (buf, start, end) {
  var bytes = buf.slice(start, end)
  var res = ''
  for (var i = 0; i < bytes.length; i += 2) {
    res += String.fromCharCode(bytes[i] + bytes[i + 1] * 256)
  }
  return res
}

Buffer.prototype.slice = function (start, end) {
  var len = this.length
  start = clamp(start, len, 0)
  end = clamp(end, len, len)

  if (Buffer._useTypedArrays) {
    return Buffer._augment(this.subarray(start, end))
  } else {
    var sliceLen = end - start
    var newBuf = new Buffer(sliceLen, undefined, true)
    for (var i = 0; i < sliceLen; i++) {
      newBuf[i] = this[i + start]
    }
    return newBuf
  }
}

// `get` will be removed in Node 0.13+
Buffer.prototype.get = function (offset) {
  console.log('.get() is deprecated. Access using array indexes instead.')
  return this.readUInt8(offset)
}

// `set` will be removed in Node 0.13+
Buffer.prototype.set = function (v, offset) {
  console.log('.set() is deprecated. Access using array indexes instead.')
  return this.writeUInt8(v, offset)
}

Buffer.prototype.readUInt8 = function (offset, noAssert) {
  if (!noAssert) {
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset < this.length, 'Trying to read beyond buffer length')
  }

  if (offset >= this.length)
    return

  return this[offset]
}

function readUInt16 (buf, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 1 < buf.length, 'Trying to read beyond buffer length')
  }

  var len = buf.length
  if (offset >= len)
    return

  var val
  if (littleEndian) {
    val = buf[offset]
    if (offset + 1 < len)
      val |= buf[offset + 1] << 8
  } else {
    val = buf[offset] << 8
    if (offset + 1 < len)
      val |= buf[offset + 1]
  }
  return val
}

Buffer.prototype.readUInt16LE = function (offset, noAssert) {
  return readUInt16(this, offset, true, noAssert)
}

Buffer.prototype.readUInt16BE = function (offset, noAssert) {
  return readUInt16(this, offset, false, noAssert)
}

function readUInt32 (buf, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 3 < buf.length, 'Trying to read beyond buffer length')
  }

  var len = buf.length
  if (offset >= len)
    return

  var val
  if (littleEndian) {
    if (offset + 2 < len)
      val = buf[offset + 2] << 16
    if (offset + 1 < len)
      val |= buf[offset + 1] << 8
    val |= buf[offset]
    if (offset + 3 < len)
      val = val + (buf[offset + 3] << 24 >>> 0)
  } else {
    if (offset + 1 < len)
      val = buf[offset + 1] << 16
    if (offset + 2 < len)
      val |= buf[offset + 2] << 8
    if (offset + 3 < len)
      val |= buf[offset + 3]
    val = val + (buf[offset] << 24 >>> 0)
  }
  return val
}

Buffer.prototype.readUInt32LE = function (offset, noAssert) {
  return readUInt32(this, offset, true, noAssert)
}

Buffer.prototype.readUInt32BE = function (offset, noAssert) {
  return readUInt32(this, offset, false, noAssert)
}

Buffer.prototype.readInt8 = function (offset, noAssert) {
  if (!noAssert) {
    assert(offset !== undefined && offset !== null,
        'missing offset')
    assert(offset < this.length, 'Trying to read beyond buffer length')
  }

  if (offset >= this.length)
    return

  var neg = this[offset] & 0x80
  if (neg)
    return (0xff - this[offset] + 1) * -1
  else
    return this[offset]
}

function readInt16 (buf, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 1 < buf.length, 'Trying to read beyond buffer length')
  }

  var len = buf.length
  if (offset >= len)
    return

  var val = readUInt16(buf, offset, littleEndian, true)
  var neg = val & 0x8000
  if (neg)
    return (0xffff - val + 1) * -1
  else
    return val
}

Buffer.prototype.readInt16LE = function (offset, noAssert) {
  return readInt16(this, offset, true, noAssert)
}

Buffer.prototype.readInt16BE = function (offset, noAssert) {
  return readInt16(this, offset, false, noAssert)
}

function readInt32 (buf, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 3 < buf.length, 'Trying to read beyond buffer length')
  }

  var len = buf.length
  if (offset >= len)
    return

  var val = readUInt32(buf, offset, littleEndian, true)
  var neg = val & 0x80000000
  if (neg)
    return (0xffffffff - val + 1) * -1
  else
    return val
}

Buffer.prototype.readInt32LE = function (offset, noAssert) {
  return readInt32(this, offset, true, noAssert)
}

Buffer.prototype.readInt32BE = function (offset, noAssert) {
  return readInt32(this, offset, false, noAssert)
}

function readFloat (buf, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset + 3 < buf.length, 'Trying to read beyond buffer length')
  }

  return ieee754.read(buf, offset, littleEndian, 23, 4)
}

Buffer.prototype.readFloatLE = function (offset, noAssert) {
  return readFloat(this, offset, true, noAssert)
}

Buffer.prototype.readFloatBE = function (offset, noAssert) {
  return readFloat(this, offset, false, noAssert)
}

function readDouble (buf, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset + 7 < buf.length, 'Trying to read beyond buffer length')
  }

  return ieee754.read(buf, offset, littleEndian, 52, 8)
}

Buffer.prototype.readDoubleLE = function (offset, noAssert) {
  return readDouble(this, offset, true, noAssert)
}

Buffer.prototype.readDoubleBE = function (offset, noAssert) {
  return readDouble(this, offset, false, noAssert)
}

Buffer.prototype.writeUInt8 = function (value, offset, noAssert) {
  if (!noAssert) {
    assert(value !== undefined && value !== null, 'missing value')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset < this.length, 'trying to write beyond buffer length')
    verifuint(value, 0xff)
  }

  if (offset >= this.length) return

  this[offset] = value
  return offset + 1
}

function writeUInt16 (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(value !== undefined && value !== null, 'missing value')
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 1 < buf.length, 'trying to write beyond buffer length')
    verifuint(value, 0xffff)
  }

  var len = buf.length
  if (offset >= len)
    return

  for (var i = 0, j = Math.min(len - offset, 2); i < j; i++) {
    buf[offset + i] =
        (value & (0xff << (8 * (littleEndian ? i : 1 - i)))) >>>
            (littleEndian ? i : 1 - i) * 8
  }
  return offset + 2
}

Buffer.prototype.writeUInt16LE = function (value, offset, noAssert) {
  return writeUInt16(this, value, offset, true, noAssert)
}

Buffer.prototype.writeUInt16BE = function (value, offset, noAssert) {
  return writeUInt16(this, value, offset, false, noAssert)
}

function writeUInt32 (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(value !== undefined && value !== null, 'missing value')
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 3 < buf.length, 'trying to write beyond buffer length')
    verifuint(value, 0xffffffff)
  }

  var len = buf.length
  if (offset >= len)
    return

  for (var i = 0, j = Math.min(len - offset, 4); i < j; i++) {
    buf[offset + i] =
        (value >>> (littleEndian ? i : 3 - i) * 8) & 0xff
  }
  return offset + 4
}

Buffer.prototype.writeUInt32LE = function (value, offset, noAssert) {
  return writeUInt32(this, value, offset, true, noAssert)
}

Buffer.prototype.writeUInt32BE = function (value, offset, noAssert) {
  return writeUInt32(this, value, offset, false, noAssert)
}

Buffer.prototype.writeInt8 = function (value, offset, noAssert) {
  if (!noAssert) {
    assert(value !== undefined && value !== null, 'missing value')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset < this.length, 'Trying to write beyond buffer length')
    verifsint(value, 0x7f, -0x80)
  }

  if (offset >= this.length)
    return

  if (value >= 0)
    this.writeUInt8(value, offset, noAssert)
  else
    this.writeUInt8(0xff + value + 1, offset, noAssert)
  return offset + 1
}

function writeInt16 (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(value !== undefined && value !== null, 'missing value')
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 1 < buf.length, 'Trying to write beyond buffer length')
    verifsint(value, 0x7fff, -0x8000)
  }

  var len = buf.length
  if (offset >= len)
    return

  if (value >= 0)
    writeUInt16(buf, value, offset, littleEndian, noAssert)
  else
    writeUInt16(buf, 0xffff + value + 1, offset, littleEndian, noAssert)
  return offset + 2
}

Buffer.prototype.writeInt16LE = function (value, offset, noAssert) {
  return writeInt16(this, value, offset, true, noAssert)
}

Buffer.prototype.writeInt16BE = function (value, offset, noAssert) {
  return writeInt16(this, value, offset, false, noAssert)
}

function writeInt32 (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(value !== undefined && value !== null, 'missing value')
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 3 < buf.length, 'Trying to write beyond buffer length')
    verifsint(value, 0x7fffffff, -0x80000000)
  }

  var len = buf.length
  if (offset >= len)
    return

  if (value >= 0)
    writeUInt32(buf, value, offset, littleEndian, noAssert)
  else
    writeUInt32(buf, 0xffffffff + value + 1, offset, littleEndian, noAssert)
  return offset + 4
}

Buffer.prototype.writeInt32LE = function (value, offset, noAssert) {
  return writeInt32(this, value, offset, true, noAssert)
}

Buffer.prototype.writeInt32BE = function (value, offset, noAssert) {
  return writeInt32(this, value, offset, false, noAssert)
}

function writeFloat (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(value !== undefined && value !== null, 'missing value')
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 3 < buf.length, 'Trying to write beyond buffer length')
    verifIEEE754(value, 3.4028234663852886e+38, -3.4028234663852886e+38)
  }

  var len = buf.length
  if (offset >= len)
    return

  ieee754.write(buf, value, offset, littleEndian, 23, 4)
  return offset + 4
}

Buffer.prototype.writeFloatLE = function (value, offset, noAssert) {
  return writeFloat(this, value, offset, true, noAssert)
}

Buffer.prototype.writeFloatBE = function (value, offset, noAssert) {
  return writeFloat(this, value, offset, false, noAssert)
}

function writeDouble (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    assert(value !== undefined && value !== null, 'missing value')
    assert(typeof littleEndian === 'boolean', 'missing or invalid endian')
    assert(offset !== undefined && offset !== null, 'missing offset')
    assert(offset + 7 < buf.length,
        'Trying to write beyond buffer length')
    verifIEEE754(value, 1.7976931348623157E+308, -1.7976931348623157E+308)
  }

  var len = buf.length
  if (offset >= len)
    return

  ieee754.write(buf, value, offset, littleEndian, 52, 8)
  return offset + 8
}

Buffer.prototype.writeDoubleLE = function (value, offset, noAssert) {
  return writeDouble(this, value, offset, true, noAssert)
}

Buffer.prototype.writeDoubleBE = function (value, offset, noAssert) {
  return writeDouble(this, value, offset, false, noAssert)
}

// fill(value, start=0, end=buffer.length)
Buffer.prototype.fill = function (value, start, end) {
  if (!value) value = 0
  if (!start) start = 0
  if (!end) end = this.length

  assert(end >= start, 'end < start')

  // Fill 0 bytes; we're done
  if (end === start) return
  if (this.length === 0) return

  assert(start >= 0 && start < this.length, 'start out of bounds')
  assert(end >= 0 && end <= this.length, 'end out of bounds')

  var i
  if (typeof value === 'number') {
    for (i = start; i < end; i++) {
      this[i] = value
    }
  } else {
    var bytes = utf8ToBytes(value.toString())
    var len = bytes.length
    for (i = start; i < end; i++) {
      this[i] = bytes[i % len]
    }
  }

  return this
}

Buffer.prototype.inspect = function () {
  var out = []
  var len = this.length
  for (var i = 0; i < len; i++) {
    out[i] = toHex(this[i])
    if (i === exports.INSPECT_MAX_BYTES) {
      out[i + 1] = '...'
      break
    }
  }
  return '<Buffer ' + out.join(' ') + '>'
}

/**
 * Creates a new `ArrayBuffer` with the *copied* memory of the buffer instance.
 * Added in Node 0.12. Only available in browsers that support ArrayBuffer.
 */
Buffer.prototype.toArrayBuffer = function () {
  if (typeof Uint8Array !== 'undefined') {
    if (Buffer._useTypedArrays) {
      return (new Buffer(this)).buffer
    } else {
      var buf = new Uint8Array(this.length)
      for (var i = 0, len = buf.length; i < len; i += 1) {
        buf[i] = this[i]
      }
      return buf.buffer
    }
  } else {
    throw new Error('Buffer.toArrayBuffer not supported in this browser')
  }
}

// HELPER FUNCTIONS
// ================

var BP = Buffer.prototype

/**
 * Augment a Uint8Array *instance* (not the Uint8Array class!) with Buffer methods
 */
Buffer._augment = function (arr) {
  arr._isBuffer = true

  // save reference to original Uint8Array get/set methods before overwriting
  arr._get = arr.get
  arr._set = arr.set

  // deprecated, will be removed in node 0.13+
  arr.get = BP.get
  arr.set = BP.set

  arr.write = BP.write
  arr.toString = BP.toString
  arr.toLocaleString = BP.toString
  arr.toJSON = BP.toJSON
  arr.equals = BP.equals
  arr.compare = BP.compare
  arr.copy = BP.copy
  arr.slice = BP.slice
  arr.readUInt8 = BP.readUInt8
  arr.readUInt16LE = BP.readUInt16LE
  arr.readUInt16BE = BP.readUInt16BE
  arr.readUInt32LE = BP.readUInt32LE
  arr.readUInt32BE = BP.readUInt32BE
  arr.readInt8 = BP.readInt8
  arr.readInt16LE = BP.readInt16LE
  arr.readInt16BE = BP.readInt16BE
  arr.readInt32LE = BP.readInt32LE
  arr.readInt32BE = BP.readInt32BE
  arr.readFloatLE = BP.readFloatLE
  arr.readFloatBE = BP.readFloatBE
  arr.readDoubleLE = BP.readDoubleLE
  arr.readDoubleBE = BP.readDoubleBE
  arr.writeUInt8 = BP.writeUInt8
  arr.writeUInt16LE = BP.writeUInt16LE
  arr.writeUInt16BE = BP.writeUInt16BE
  arr.writeUInt32LE = BP.writeUInt32LE
  arr.writeUInt32BE = BP.writeUInt32BE
  arr.writeInt8 = BP.writeInt8
  arr.writeInt16LE = BP.writeInt16LE
  arr.writeInt16BE = BP.writeInt16BE
  arr.writeInt32LE = BP.writeInt32LE
  arr.writeInt32BE = BP.writeInt32BE
  arr.writeFloatLE = BP.writeFloatLE
  arr.writeFloatBE = BP.writeFloatBE
  arr.writeDoubleLE = BP.writeDoubleLE
  arr.writeDoubleBE = BP.writeDoubleBE
  arr.fill = BP.fill
  arr.inspect = BP.inspect
  arr.toArrayBuffer = BP.toArrayBuffer

  return arr
}

var INVALID_BASE64_RE = /[^+\/0-9A-z]/g

function base64clean (str) {
  // Node strips out invalid characters like \n and \t from the string, base64-js does not
  str = stringtrim(str).replace(INVALID_BASE64_RE, '')
  // Node allows for non-padded base64 strings (missing trailing ===), base64-js does not
  while (str.length % 4 !== 0) {
    str = str + '='
  }
  return str
}

function stringtrim (str) {
  if (str.trim) return str.trim()
  return str.replace(/^\s+|\s+$/g, '')
}

// slice(start, end)
function clamp (index, len, defaultValue) {
  if (typeof index !== 'number') return defaultValue
  index = ~~index;  // Coerce to integer.
  if (index >= len) return len
  if (index >= 0) return index
  index += len
  if (index >= 0) return index
  return 0
}

function coerce (length) {
  // Coerce length to a number (possibly NaN), round up
  // in case it's fractional (e.g. 123.456) then do a
  // double negate to coerce a NaN to 0. Easy, right?
  length = ~~Math.ceil(+length)
  return length < 0 ? 0 : length
}

function isArray (subject) {
  return (Array.isArray || function (subject) {
    return Object.prototype.toString.call(subject) === '[object Array]'
  })(subject)
}

function isArrayish (subject) {
  return isArray(subject) || Buffer.isBuffer(subject) ||
      subject && typeof subject === 'object' &&
      typeof subject.length === 'number'
}

function toHex (n) {
  if (n < 16) return '0' + n.toString(16)
  return n.toString(16)
}

function utf8ToBytes (str) {
  var byteArray = []
  for (var i = 0; i < str.length; i++) {
    var b = str.charCodeAt(i)
    if (b <= 0x7F) {
      byteArray.push(b)
    } else {
      var start = i
      if (b >= 0xD800 && b <= 0xDFFF) i++
      var h = encodeURIComponent(str.slice(start, i+1)).substr(1).split('%')
      for (var j = 0; j < h.length; j++) {
        byteArray.push(parseInt(h[j], 16))
      }
    }
  }
  return byteArray
}

function asciiToBytes (str) {
  var byteArray = []
  for (var i = 0; i < str.length; i++) {
    // Node's code seems to be doing this and not & 0x7F..
    byteArray.push(str.charCodeAt(i) & 0xFF)
  }
  return byteArray
}

function utf16leToBytes (str) {
  var c, hi, lo
  var byteArray = []
  for (var i = 0; i < str.length; i++) {
    c = str.charCodeAt(i)
    hi = c >> 8
    lo = c % 256
    byteArray.push(lo)
    byteArray.push(hi)
  }

  return byteArray
}

function base64ToBytes (str) {
  return base64.toByteArray(str)
}

function blitBuffer (src, dst, offset, length) {
  for (var i = 0; i < length; i++) {
    if ((i + offset >= dst.length) || (i >= src.length))
      break
    dst[i + offset] = src[i]
  }
  return i
}

function decodeUtf8Char (str) {
  try {
    return decodeURIComponent(str)
  } catch (err) {
    return String.fromCharCode(0xFFFD) // UTF 8 invalid char
  }
}

/*
 * We have to make sure that the value is a valid integer. This means that it
 * is non-negative. It has no fractional component and that it does not
 * exceed the maximum allowed value.
 */
function verifuint (value, max) {
  assert(typeof value === 'number', 'cannot write a non-number as a number')
  assert(value >= 0, 'specified a negative value for writing an unsigned value')
  assert(value <= max, 'value is larger than maximum value for type')
  assert(Math.floor(value) === value, 'value has a fractional component')
}

function verifsint (value, max, min) {
  assert(typeof value === 'number', 'cannot write a non-number as a number')
  assert(value <= max, 'value larger than maximum allowed value')
  assert(value >= min, 'value smaller than minimum allowed value')
  assert(Math.floor(value) === value, 'value has a fractional component')
}

function verifIEEE754 (value, max, min) {
  assert(typeof value === 'number', 'cannot write a non-number as a number')
  assert(value <= max, 'value larger than maximum allowed value')
  assert(value >= min, 'value smaller than minimum allowed value')
}

function assert (test, message) {
  if (!test) throw new Error(message || 'Failed assertion')
}

},{"base64-js":5,"ieee754":6}],5:[function(require,module,exports){
var lookup = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

;(function (exports) {
	'use strict';

  var Arr = (typeof Uint8Array !== 'undefined')
    ? Uint8Array
    : Array

	var PLUS   = '+'.charCodeAt(0)
	var SLASH  = '/'.charCodeAt(0)
	var NUMBER = '0'.charCodeAt(0)
	var LOWER  = 'a'.charCodeAt(0)
	var UPPER  = 'A'.charCodeAt(0)

	function decode (elt) {
		var code = elt.charCodeAt(0)
		if (code === PLUS)
			return 62 // '+'
		if (code === SLASH)
			return 63 // '/'
		if (code < NUMBER)
			return -1 //no match
		if (code < NUMBER + 10)
			return code - NUMBER + 26 + 26
		if (code < UPPER + 26)
			return code - UPPER
		if (code < LOWER + 26)
			return code - LOWER + 26
	}

	function b64ToByteArray (b64) {
		var i, j, l, tmp, placeHolders, arr

		if (b64.length % 4 > 0) {
			throw new Error('Invalid string. Length must be a multiple of 4')
		}

		// the number of equal signs (place holders)
		// if there are two placeholders, than the two characters before it
		// represent one byte
		// if there is only one, then the three characters before it represent 2 bytes
		// this is just a cheap hack to not do indexOf twice
		var len = b64.length
		placeHolders = '=' === b64.charAt(len - 2) ? 2 : '=' === b64.charAt(len - 1) ? 1 : 0

		// base64 is 4/3 + up to two characters of the original data
		arr = new Arr(b64.length * 3 / 4 - placeHolders)

		// if there are placeholders, only get up to the last complete 4 chars
		l = placeHolders > 0 ? b64.length - 4 : b64.length

		var L = 0

		function push (v) {
			arr[L++] = v
		}

		for (i = 0, j = 0; i < l; i += 4, j += 3) {
			tmp = (decode(b64.charAt(i)) << 18) | (decode(b64.charAt(i + 1)) << 12) | (decode(b64.charAt(i + 2)) << 6) | decode(b64.charAt(i + 3))
			push((tmp & 0xFF0000) >> 16)
			push((tmp & 0xFF00) >> 8)
			push(tmp & 0xFF)
		}

		if (placeHolders === 2) {
			tmp = (decode(b64.charAt(i)) << 2) | (decode(b64.charAt(i + 1)) >> 4)
			push(tmp & 0xFF)
		} else if (placeHolders === 1) {
			tmp = (decode(b64.charAt(i)) << 10) | (decode(b64.charAt(i + 1)) << 4) | (decode(b64.charAt(i + 2)) >> 2)
			push((tmp >> 8) & 0xFF)
			push(tmp & 0xFF)
		}

		return arr
	}

	function uint8ToBase64 (uint8) {
		var i,
			extraBytes = uint8.length % 3, // if we have 1 byte left, pad 2 bytes
			output = "",
			temp, length

		function encode (num) {
			return lookup.charAt(num)
		}

		function tripletToBase64 (num) {
			return encode(num >> 18 & 0x3F) + encode(num >> 12 & 0x3F) + encode(num >> 6 & 0x3F) + encode(num & 0x3F)
		}

		// go through the array every three bytes, we'll deal with trailing stuff later
		for (i = 0, length = uint8.length - extraBytes; i < length; i += 3) {
			temp = (uint8[i] << 16) + (uint8[i + 1] << 8) + (uint8[i + 2])
			output += tripletToBase64(temp)
		}

		// pad the end with zeros, but make sure to not forget the extra bytes
		switch (extraBytes) {
			case 1:
				temp = uint8[uint8.length - 1]
				output += encode(temp >> 2)
				output += encode((temp << 4) & 0x3F)
				output += '=='
				break
			case 2:
				temp = (uint8[uint8.length - 2] << 8) + (uint8[uint8.length - 1])
				output += encode(temp >> 10)
				output += encode((temp >> 4) & 0x3F)
				output += encode((temp << 2) & 0x3F)
				output += '='
				break
		}

		return output
	}

	exports.toByteArray = b64ToByteArray
	exports.fromByteArray = uint8ToBase64
}(typeof exports === 'undefined' ? (this.base64js = {}) : exports))

},{}],6:[function(require,module,exports){
exports.read = function(buffer, offset, isLE, mLen, nBytes) {
  var e, m,
      eLen = nBytes * 8 - mLen - 1,
      eMax = (1 << eLen) - 1,
      eBias = eMax >> 1,
      nBits = -7,
      i = isLE ? (nBytes - 1) : 0,
      d = isLE ? -1 : 1,
      s = buffer[offset + i];

  i += d;

  e = s & ((1 << (-nBits)) - 1);
  s >>= (-nBits);
  nBits += eLen;
  for (; nBits > 0; e = e * 256 + buffer[offset + i], i += d, nBits -= 8);

  m = e & ((1 << (-nBits)) - 1);
  e >>= (-nBits);
  nBits += mLen;
  for (; nBits > 0; m = m * 256 + buffer[offset + i], i += d, nBits -= 8);

  if (e === 0) {
    e = 1 - eBias;
  } else if (e === eMax) {
    return m ? NaN : ((s ? -1 : 1) * Infinity);
  } else {
    m = m + Math.pow(2, mLen);
    e = e - eBias;
  }
  return (s ? -1 : 1) * m * Math.pow(2, e - mLen);
};

exports.write = function(buffer, value, offset, isLE, mLen, nBytes) {
  var e, m, c,
      eLen = nBytes * 8 - mLen - 1,
      eMax = (1 << eLen) - 1,
      eBias = eMax >> 1,
      rt = (mLen === 23 ? Math.pow(2, -24) - Math.pow(2, -77) : 0),
      i = isLE ? 0 : (nBytes - 1),
      d = isLE ? 1 : -1,
      s = value < 0 || (value === 0 && 1 / value < 0) ? 1 : 0;

  value = Math.abs(value);

  if (isNaN(value) || value === Infinity) {
    m = isNaN(value) ? 1 : 0;
    e = eMax;
  } else {
    e = Math.floor(Math.log(value) / Math.LN2);
    if (value * (c = Math.pow(2, -e)) < 1) {
      e--;
      c *= 2;
    }
    if (e + eBias >= 1) {
      value += rt / c;
    } else {
      value += rt * Math.pow(2, 1 - eBias);
    }
    if (value * c >= 2) {
      e++;
      c /= 2;
    }

    if (e + eBias >= eMax) {
      m = 0;
      e = eMax;
    } else if (e + eBias >= 1) {
      m = (value * c - 1) * Math.pow(2, mLen);
      e = e + eBias;
    } else {
      m = value * Math.pow(2, eBias - 1) * Math.pow(2, mLen);
      e = 0;
    }
  }

  for (; mLen >= 8; buffer[offset + i] = m & 0xff, i += d, m /= 256, mLen -= 8);

  e = (e << mLen) | m;
  eLen += mLen;
  for (; eLen > 0; buffer[offset + i] = e & 0xff, i += d, e /= 256, eLen -= 8);

  buffer[offset + i - d] |= s * 128;
};

},{}]},{},[3])
