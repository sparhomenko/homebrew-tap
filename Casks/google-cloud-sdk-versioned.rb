cask "google-cloud-sdk-versioned" do
  version "373.0.0"
  sha256 "3e0f98c2595594c95d6898b02bcfc3ced8a363199bdf823580d097dc9b1c8962"

  url "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-#{version}-darwin-x86_64.tar.gz"
  name "Google Cloud SDK"
  desc "Set of tools to manage resources and applications hosted on Google Cloud"
  homepage "https://cloud.google.com/sdk/"

  livecheck do
    url "https://dl.google.com/dl/cloudsdk/channels/rapid/components-2.json"
    regex(/  "version": "(\d+\.\d+\.\d+)"\n\}$/i)
  end

  auto_updates true
  conflicts_with cask: "google-cloud-sdk"
  depends_on formula: "python"

  installer script: {
    executable: "google-cloud-sdk/install.sh",
    args:       [
      "--usage-reporting", "false", "--bash-completion", "false", "--path-update", "false",
      "--rc-path", "false", "--quiet",
      "--install-python", "false"
    ] + (
      if ENV.key?("HOMEBREW_GOOGLE_CLOUD_SDK_ADDITIONAL_COMPONENTS")
        ["--additional-components"] + ENV["HOMEBREW_GOOGLE_CLOUD_SDK_ADDITIONAL_COMPONENTS"].split(",")
      else
        []
      end
    ),
  }
  binary "#{HOMEBREW_PREFIX}/share/google-cloud-sdk/bin/anthoscli"
  binary "#{HOMEBREW_PREFIX}/share/google-cloud-sdk/bin/bq"
  binary "#{HOMEBREW_PREFIX}/share/google-cloud-sdk/bin/docker-credential-gcloud"
  binary "#{HOMEBREW_PREFIX}/share/google-cloud-sdk/bin/gcloud"
  binary "#{HOMEBREW_PREFIX}/share/google-cloud-sdk/bin/git-credential-gcloud.sh", target: "git-credential-gcloud"
  binary "#{HOMEBREW_PREFIX}/share/google-cloud-sdk/bin/gsutil"
  artifact "google-cloud-sdk", target: "#{HOMEBREW_PREFIX}/share/google-cloud-sdk"

  # Not actually necessary, since it would be deleted anyway.
  # It is present to make clear an uninstall was not forgotten and that for this cask it is indeed this simple.
  uninstall delete: "#{staged_path}/google-cloud-sdk"

  # https://cloud.google.com/sdk/docs/uninstall-cloud-sdk
  zap trash: [
    "~/.config/gcloud",
    "~/Library/Caches/**/google-cloud-sdk",
  ]

  caveats <<~EOS
    To install shell completions, add this to your profile:
      for bash users
        source "#{HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.bash.inc"
      for zsh users
        source "#{HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.zsh.inc"

    To keep additional components after an upgrade or reinstallation add to your profile:
    export HOMEBREW_GOOGLE_CLOUD_SDK_ADDITIONAL_COMPONENTS='COMPONENT_ID,COMPONENT_ID'
  EOS
end
