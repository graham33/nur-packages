{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, homeassistant
}:

buildPythonPackage rec {
  pname = "homeassistant-stubs";
  version = "2021.11.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = pname;
    rev = "${version}";
    sha256 = "0frcclyq3n1sfrpy2j6rs124mqj63nbn5vzn5kyy9ldza3fz030j";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    homeassistant
  ];

  pythonImportsCheck = [ "homeassistant-stubs" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/KapJI/homeassistant-stubs";
    license = licenses.mit;
    description = "PEP 484 typing stubs for Home Assistant Core";
    maintainers = with maintainers; [ graham33 ];
  };
}
