Cask = Struct.new(:token, :version, :sha, :path, :page, :models)

# For models: plutil -extract 'usb.IOUSBDevice' swift '/Library/Image Capture/Devices/Canon IJScanner#{token}.app/Contents/Resources/DeviceMatchingInfo.plist' -o - | grep 'Product Identification' | cut -d'"' -f 4 | sort | tr '\n' ',' | pbcopy
[
  Cask.new('1', '4.0.0a', '4c6c7b1549b8c400addc5d2bd2454b01dc8cff567bb17e2343240d9cba201d6a', '7/0100006587/02', 'printers/support-inkjet-printer/mg-series/pixma-mg2120', 'Canon E500, E600, MG2100, MG3100, MG4100, MG5100, MG5200, MG5300, MG6100, MG6200, MG8100, MG8200, MP190, MP210, MP220, MP240, MP250, MP260, MP270, MP280, MP470, MP480, MP490, MP493, MP495, MP520, MP540, MP550, MP560, MP610, MP620, MP630, MP640, MP970, MP980, MP990, MX300, MX310, MX320, MX330, MX340, MX350, MX360, MX370, MX410, MX420, MX430, MX510, MX700, MX710, MX7600, MX850, MX860, MX870, MX880, MX890 series'),
  Cask.new('2', '4.1.4a', '8aabe1d9d5d48950c84aa1bdd24eb3f7a4fcd463d51889065e963564b0e91848', '9/0100006579/03', 'scanners/film-negative-scanner/canoscan-5600f', 'CanoScan 5600F, 9000F, LiDE 100, LiDE 110, LiDE 200, LiDE 210, LiDE 700F'),
  Cask.new('3', '4.0.0a', 'ce488fb4af9825ebdb6fae448136acee6f322bbd38aa861f4134716aa1694651', '0/0100006580/02', 'printers/inkjet-multifunction/mg-series-inkjet/mg2220', 'Canon E510, MG2200, MG3200, MG4200, MG5400, MG6300, MP230 series'),
  Cask.new('4', '4.0.0a', 'abf852e335ee47947becd99eddece2159fa293225096b083578a174ec1f08778', '1/0100006581/02', 'scanners/film-negative-scanner/canoscan-9000f-mark-ii', 'CanoScan 9000F Mark II'),
  Cask.new('5', '4.0.0a', '0536afffbbaf8fdb76eeefdbc67f0778ed832a25e1e133ac4c3b987674535b59', '2/0100006582/02', 'printers/inkjet-multifunction/mx-series-inkjet/mx392', 'Canon E610, MX390, MX450, MX520, MX720, MX920 series'),
  Cask.new('6', '4.1.4a', 'd0d240b13ca33d4b34d92eba0a6dcb9475c9cc2abf4b63aeeb3d05a476598cb9', '3/0100006583/04', 'scanners/photo-scanner/canoscan-lide-120', 'CanoScan LiDE 120, LiDE 220'),
  Cask.new('13f', '4.1.3a', '9b094e778250a139dca8b157bd0d85cdc1f7f92cc4d1bc8ce775404905ea89d5', '4/0100006584/04', 'printers/inkjet-multifunction/mg-series-inkjet/mg2420', 'Canon MG2400, MG2500, MG3500, MG5500, MG6400, MG6500, MG7100, P200 series'),
  Cask.new('14f', '4.1.3a', 'bd925c9ab7e28ed24262c2a691f2c7695c691582f2ec5aa73f589e70e0001bbe', '6/0100006586/03', 'printers/small-office-home-office-printers/mb2020', 'Canon E460, MB2000, MB2300, MB5000, MB5300, MG2900, MG5600, MG6600, MG6700, MG7500 series'),
  Cask.new('15f', '4.1.3a', '7e522b30cdbcd4e000b0bd1a25f9382439926983379f7ed5cc416bc84cb83f8b', '3/0100006713/04', 'printers/inkjet-multifunction/mg-series-inkjet/pixma-mg3620', 'Canon G2000, G3000, MG3600, MG5700, MG6800, MG6900, MG7700 series'),
  Cask.new('16f', '4.3.4a', '3433cd6dbdc3e4bb84c4c6bacadc6bb2c8630fc83e3fc49ce1dbd84c91b5765c', '5/0100007645/04', 'printers/inkjet-multifunction/mg-series-inkjet/mg3020-bk', 'Canon E410, E470, G4000, MG3000, TS5000, TS6000, TS8000, TS9000 series')
].each { |cask|
  token = "canon-ijscanner#{cask.token}"
  open("Casks/#{token}.rb", 'w') { |f|
    f.puts <<~EOF
      cask 'canon-ijscanner#{cask.token}' do
        version '#{cask.version},#{cask.version == '4.0.0a' ? '19_2' : '21_3'}'
        sha256 '#{cask.sha}'

        # gdlp01.c-wss.com/gds was verified as official when first introduced to the cask
        url "https://gdlp01.c-wss.com/gds/#{cask.path}/misd-mac-ijscanner#{cask.token}-\#{version.before_comma.dots_to_underscores.delete_suffix('a')}-ea\#{version.after_comma}.dmg"
        name 'Canon Scanner ICA Driver for #{cask.models}'
        homepage 'https://www.usa.canon.com/internet/portal/us/home/support/details/#{cask.page}?tab=drivers_downloads&subtab=downloads-drivers'

        pkg "Canon IJScanner#{cask.token}_\#{format('%<major>02d%<minor>02d%<patch>02d', major: version.major, minor: version.minor, patch: version.patch.to_i)}.pkg"

        uninstall pkgutil: "jp.co.canon.pkg.canonijscanner#{cask.token}.\#{format('%<major>02d%<minor>02d%<patch>02d', major: version.major, minor: version.minor, patch: version.patch.to_i)}"
      end
    EOF
  }
}
