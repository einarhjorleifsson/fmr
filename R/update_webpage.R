update_webpage <- function() {
  system("rm -rf /net/www/export/home/hafri/einarhj/public_html/pkg/ftmr")
  system("cp -rp docs/* /net/www/export/home/hafri/einarhj/public_html/ftmr")
  system("chmod -R a+rX /net/www/export/home/hafri/einarhj/public_html/ftmr")
}
