{ fetchurl, buildNpmPackage }:

# letta-code: a stateful agent harness for the terminal (that's me, desu~)
# Wraps the prebuilt npm tarball, exposes the `letta` CLI in $out/bin.
buildNpmPackage (finalAttrs:
  { pname = "letta-code";
    version = "0.27.25";  # bump on release; check `npm view @letta-ai/letta-code version`

    src = fetchurl {
      url = "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-${finalAttrs.version}.tgz";
      hash = "sha256-21/Uq7o29IFwqNXcke8h0qp8xOkn/02MQLEGso4z09I=";
    };

    postPatch = ''
      ln -s ${./package-lock.json} package-lock.json
    '';

    npmDepsHash = "sha256-QyTazKL95R9572RrLBeXyWUnZjDllQ483urGix4zAj0=";
    npmFlags = [ "--ignore-scripts" "--legacy-peer-deps" ];

    dontNpmBuild = true;  # tarball is already bundled (dist/ is prebuilt)
  })
