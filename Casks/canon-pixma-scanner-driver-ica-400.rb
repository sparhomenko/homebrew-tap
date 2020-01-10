cask 'canon-pixma-scanner-driver-ica-400' do
  version '4.0.0'
  sha256 '4c6c7b1549b8c400addc5d2bd2454b01dc8cff567bb17e2343240d9cba201d6a'

  # gdlp01.c-wss.com/gds was verified as official when first introduced to the cask
  url "https://gdlp01.c-wss.com/gds/7/0100006587/02/misd-mac-ijscanner1-#{version.dots_to_underscores}-ea19_2.dmg"
  name 'Canon PIXMA ICA Scanner Driver'
  homepage 'https://www.usa.canon.com/internet/portal/us/home/support/details/printers/support-inkjet-printer/mg-series/pixma-mg6220'

  pkg "Canon IJScanner1_#{format('%<major>02d%<minor>02d%<patch>02d', major: version.major, minor: version.minor, patch: version.patch)}.pkg"

  uninstall pkgutil: "jp.co.canon.pkg.canonijscanner1.#{format('%<major>02d%<minor>02d%<patch>02d', major: version.major, minor: version.minor, patch: version.patch)}"
end
