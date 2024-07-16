{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=249fbde2a178a2ea2638b65b9ecebd531b338cf9";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let 
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = pkgs.lib;
    in rec {
      default = pkgs.buildEnv {
        name = "gnuradio-env";
        paths = [ python ];
      };
      python = 
          (pkgs.gnuradio.python.withPackages (python-pkgs: [
            python-pkgs.pyzmq
          ] ++ pkgs.gnuradio.pythonPkgs
          ));
      shell = pkgs.mkShellNoCC {
        packages = [ default ];
      };
    };

    devShells.x86_64-linux.default = self.packages.x86_64-linux.shell;
  };
}
