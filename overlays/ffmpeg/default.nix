final: prev: {
  ffmpeg-headless = prev.ffmpeg-headless.overrideAttrs {
    doCheck = false;
  };
  ffmpeg = prev.ffmpeg-headless.overrideAttrs {
    doCheck = false;
  };
}
