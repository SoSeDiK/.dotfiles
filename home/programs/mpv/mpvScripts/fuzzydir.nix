{
  fetchFromGitHub,
  buildLua,
}:
buildLua {
  pname = "fuzzydir";
  version = "10-06-2024";

  src = fetchFromGitHub {
    owner = "sibwaf";
    repo = "mpv-scripts";
    rev = "e4fb662207e024f26d7763c9551e429898267974";
    hash = "sha256-zD1C4+dor0hr2FnZi+8jJKm8EQ1zA/6WYopG+Bjs7/0=";
  };
}
