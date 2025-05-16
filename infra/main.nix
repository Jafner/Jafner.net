{ config, ... }: let account_id = "9c3bc49e4d283320f5df4fc2e8ed9acc"; in {
  terraform.required_providers.cloudflare = { source = "cloudflare/cloudflare"; version = "~> 4"; };
  terraform.backend.s3 = {
    bucket = "terraform";
    key = "main.tfstate";
    region = "auto";
    skip_credentials_validation = true;
    skip_metadata_api_check = true;
    skip_region_validation = true;
    skip_requesting_account_id = true;
    skip_s3_checksum = true;
    use_path_style = true;
    endpoints.s3 = "https://${account_id}.r2.cloudflarestorage.com";
    # Credentials should be provided via:
    # -backend-config="access_key=..." -backend-config="secret_key=..."
  };
  provider.cloudflare = {};
  variable.account_id = { default = "${account_id}"; };
  resource.cloudflare_r2_bucket.backend = {
    account_id = "${config.variable.account_id.default}";
    name = "terraform";
  };
}
