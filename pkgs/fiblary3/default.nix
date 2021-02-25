{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, fixtures
, jsonpatch
, mock
, netaddr
, prettytable
, pytestCheckHook
, python-dateutil
, requests
, requests-mock
, six
, sphinx
, testtools
}:

buildPythonPackage rec {
  pname = "fiblary3";
  version = "0.1.8";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    # TODO: fix
    owner = "graham33";
    repo = "fiblary";
    rev = "0d04befbaacbe56a3c59ca4fb862732639abebeb";
    sha256 = "1h332f68mq89qshqwn781wzz5mg2359j0636j2qr8fh3jw10kkzp";
  };

  nativeBuildInputs = [
    sphinx
  ];

  propagatedBuildInputs = [
    jsonpatch
    netaddr
    prettytable
    python-dateutil
    requests
    six
  ];

  checkInputs = [
    fixtures
    mock
    pytestCheckHook
    requests-mock
    testtools
  ];

  pythonImportsCheck = [ "fiblary3" ];

  meta = with lib; {
    homepage = "https://github.com/pbalogh77/fiblary";
    description = "Fibaro Home Center API Python Library";
    license = licenses.asl20;
    #maintainers = with maintainers; [ graham33 ];
  };
}
