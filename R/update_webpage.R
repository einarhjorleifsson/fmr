update_webpage <- function() {
  system("rm -rf /net/www/export/home/hafri/einarhj/public_html/ftr/*")
  system("cp -rp docs/* /net/www/export/home/hafri/einarhj/public_html/ftr/.")
  system("chmod -R a+rX /net/www/export/home/hafri/einarhj/public_html/ftr")
}
