{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    modules.ops.enable =
      lib.mkEnableOption "Enables cloud and Kubernetes operations tooling.";
  };

  config = lib.mkIf config.modules.ops.enable {
    home.packages = with pkgs; [
      auth0-cli
      kubectl
      (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
      ]))
    ];

    home.shellAliases = {
      k = "kubectl";
    };

    home.sessionVariables = {
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    };

    programs.bash.initExtra = ''
      # kubectl completion on `k` alias
      source <(kubectl completion bash | sed 's|__start_kubectl kubectl|__start_kubectl k|g')
    '';
  };
}
