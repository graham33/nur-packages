{ lib
, buildPythonPackage
, aiohttp
, click
, fetchFromGitHub
, freezegun
, isPy3k
, pytest
, pytest-asyncio
, pytest-mock
, pytest-randomly
, pytestCheckHook
, python-socketio_4
, pyyaml
, requests
, requests-mock
, websocket_client
}:

buildPythonPackage rec {
  pname = "smartbox";
  version = "0.5.4";
  format = "pyproject";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "graham33";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:05n8s4c7c5g51y8k63dqjbvyymh79v3n0c0mw5fa7w5q16ay1mr0";
  };

  propagatedBuildInputs = [ aiohttp
                            click
                            python-socketio_4
                            pyyaml
                            requests
                            websocket_client
                          ];

  checkInputs = [
    freezegun
    pytest
    pytest-asyncio
    pytest-mock
    pytest-randomly
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    homepage = "https://github.com/graham33/smartbox";
    license = licenses.mit;
    description = "Python API to control heating 'smart boxes'.";
    maintainers = with maintainers; [ graham33 ];
  };
}
