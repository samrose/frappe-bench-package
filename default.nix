#{ lib
#, python3
#, fetchFromGitHub
#}:
with import <nixpkgs> {}; let
  py = python3.override {
    packageOverrides = self: super: {
      jinja2 = super.jinja2.overrideAttrs (oldAttrs: {
        src = super.fetchPypi {
          pname = "Jinja2";
          version = "3.0.3";
          hash = "sha256-YRuyc81o87mT+r3EBk/IWMW0epc8tap5mewbpAXIfNc=";
        };
      });
      semantic-version = super.semantic-version.overrideAttrs (oldAttrs: {
        src = super.fetchPypi {
          pname = "semantic_version";
          version = "2.8.2";
          hash = "sha256-cccW6ZCGxE0GgmK4bkd1qm23+r7gdD5OM7APv29nJYU=";
        };
      });
      smmap = super.smmap.overrideAttrs (oldAttrs: {
        src = super.fetchPypi {
          pname = "smmap2";
          version = "2.0.5";
          hash = "sha256-Kan/oEl+fyvpTKDtHKGqPNTPJaH2tPX4f3S0btkdYJo=";
        };
      });
      gitdb = super.gitdb.overrideAttrs (oldAttrs: {
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "gitdb";
          rev = "2.0.6";
          hash = "sha256-q8+IOhVRuCmFnldoerEZnWwrx3NLq09rSu6ql/wPc+Q=";
        };
      });
      GitPython = super.GitPython.overrideAttrs (oldAttrs: {
        pname = "gitpython";
        version = "2.1.15";
        format = "setuptools";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "GitPython";
          rev = "2.1.15";
          hash = "sha256-XxlC5ahyga9ca+uQdqisRh0G/u6wO5lXiPssBwEnT4U=";
        };
      });
    };
  };
in
  py.pkgs.buildPythonApplication rec {
    pname = "bench";
    version = "5.16.0";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "frappe";
      repo = "bench";
      rev = "v${version}";
      hash = "sha256-K4UQfIyuFsO2jZLXs6l4dsJjsDuGUHsbveEaxPJaUwI=";
    };

    propagatedBuildInputs = with py.pkgs; [
      click
      GitPython
      hatchling
      honcho
      jinja2
      python-crontab
      requests
      semantic-version
      setuptools
      smmap
      tomli
    ];

    pythonImportsCheck = ["bench"];

    meta = with lib; {
      description = "CLI to manage Multi-tenant deployments for Frappe apps";
      homepage = "https://github.com/frappe/bench";
      license = with licenses; [gpl3Only gpl3];
      maintainers = with maintainers; [];
    };
  }
