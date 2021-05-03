{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, python3
, gettext
, file
, libvorbis
, libmad
, libjack2
, lv2
, lilv
, serd
, sord
, sratom
, suil
, alsaLib
, libsndfile
, soxr
, flac
, twolame
, expat
, libid3tag
, libopus
, ffmpeg
, soundtouch
, pcre /*, portaudio - given up fighting their portaudio.patch */
, at-spi2-core ? null
, dbus ? null
, epoxy ? null
, libXdmcp ? null
, libXtst ? null
, libpthreadstubs ? null
, libselinux ? null
, libsepol ? null
, libxkbcommon ? null
, utillinux ? null
}:

# TODO
# - as of 3.0.2, GTK2 is still the recommended version ref https://www.audacityteam.org/download/source/ check if that changes in future versions
# - detach sbsms

stdenv.mkDerivation rec {
  pname = "audacity";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "audacity";
    repo = "audacity";
    rev = "Audacity-${version}";
    sha256 = "035qq2ff16cdl2cb9iply2bfjmhfl1dpscg79x6c9l0i9m8k41zj";
  };

  # workaround for a broken cmake. Drop it with a later version to see if it works.
  # https://github.com/NixOS/nixpkgs/issues/94905
  cmakeFlags = lib.optional stdenv.isLinux "-DCMAKE_OSX_ARCHITECTURES=";

  # audacity only looks for ffmpeg at runtime, so we need to link it in manually
  NIX_LDFLAGS = toString [
    # ffmpeg
    "-lavcodec"
    "-lavdevice"
    "-lavfilter"
    "-lavformat"
    "-lavresample"
    "-lavutil"
    "-lpostproc"
    "-lswresample"
    "-lswscale"
  ];

  nativeBuildInputs = [ cmake gettext pkg-config python3 ];

  buildInputs = [
    alsaLib
    expat
    ffmpeg
    file
    flac
    libid3tag
    libjack2
    libmad
    libopus
    libsndfile
    libvorbis
    lilv
    lv2
    pcre
    serd
    sord
    soundtouch
    soxr
    sratom
    suil
    twolame
    import ./wxWidgets-audacity.nix {}
  ] ++ lib.optionals stdenv.isLinux [
    at-spi2-core
    dbus
    epoxy
    libXdmcp
    libXtst
    libpthreadstubs
    libxkbcommon
    libselinux
    libsepol
    utillinux
  ];

  doCheck = false; # Test fails

  meta = with lib; {
    description = "Sound editor with graphical UI";
    homepage = "https://www.audacityteam.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lheckemann ];
    platforms = platforms.linux;
  };
}
