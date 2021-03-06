require 'formula'

class Libsass < Formula
  homepage 'https://github.com/hcatlin/libsass'
  url 'https://github.com/hcatlin/libsass/archive/v1.0.1.tar.gz'
  sha1 '9524e028bc8ebe84e36895269d07ecc7db496c7c'

  bottle do
    cellar :any
    sha1 "f9692db61866cd9b047bba78438336fbf91d9f12" => :mavericks
    sha1 "3b5ed220b8247bf9178299f0a1ddd687966d4251" => :mountain_lion
    sha1 "79a794c000d6adf225cf60d81ce930b01af777d2" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <sass_interface.h>
      #include <string.h>

      int main()
      {
        struct sass_context* sass_ctx = sass_new_context();
        struct sass_options options;
        options.output_style = SASS_STYLE_NESTED;
        options.source_comments = 0;
        options.image_path = "images";
        options.include_paths = "";
        sass_ctx->source_string = "a { color:blue; &:hover { color:red; } }";
        sass_ctx->options = options;
        sass_compile(sass_ctx);
        if(sass_ctx->error_status) {
          return 1;
        } else {
          return strcmp(sass_ctx->output_string, "a {\\n  color: blue; }\\n  a:hover {\\n    color: red; }\\n") != 0;
        }
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-lsass"
    system "./test"
  end
end
