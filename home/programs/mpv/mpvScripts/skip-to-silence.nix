{
  fetchFromGitHub,
  buildLua,
}:
buildLua {
  pname = "skiptosilence";
  version = "27-02-2022";

  src = fetchFromGitHub {
    owner = "detuur";
    repo = "mpv-scripts";
    rev = "0125d5eaaa6614464fbb0ee4fb7aa22a942367e8";
    hash = "sha256-b3Z9T1NfNdUzUF3to1DhBm6CpiXnoBDfaRqzXrIE8ds=";
  };
}
