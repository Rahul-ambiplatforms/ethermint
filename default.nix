{ lib
, buildGoApplication
, nix-gitignore
, rev ? "dirty"
}:
let
  version = "v0.1.1";
  pname = "ethermintd";
  tags = [ "ledger" "netgo" ];
  ldflags = lib.concatStringsSep "\n" ([
    "-X github.com/cosmos/cosmos-sdk/version.Name=ethermint"
    "-X github.com/cosmos/cosmos-sdk/version.AppName=${pname}"
    "-X github.com/cosmos/cosmos-sdk/version.Version=${version}"
    "-X github.com/cosmos/cosmos-sdk/version.BuildTags=${lib.concatStringsSep "," tags}"
    "-X github.com/cosmos/cosmos-sdk/version.Commit=${rev}"
  ]);
in
buildGoApplication rec {
  inherit pname version tags ldflags;
  src = (nix-gitignore.gitignoreSourcePure [
    "../*" # ignore all, then add whitelists
    "!../x/"
    "!../app/"
    "!../cmd/"
    "!../client/"
    "!../server/"
    "!../crypto/"
    "!../rpc/"
    "!../types/"
    "!../encoding/"
    "!../go.mod"
    "!../go.sum"
    "!../gomod2nix.toml"
  ] ./.);
  modules = ./gomod2nix.toml;
  doCheck = false;
  pwd = src; # needed to support replace
  subPackages = [ "cmd/ethermintd" ];
  CGO_ENABLED = "1";

  meta = with lib; {
    description = "Ethermint is a scalable and interoperable Ethereum library, built on Proof-of-Stake with fast-finality using the Cosmos SDK which runs on top of Tendermint Core consensus engine.";
    homepage = "https://github.com/Ambiplatforms-TORQUE/ethermint";
    license = licenses.asl20;
    mainProgram = "ethermintd";
  };
}