update_webpage <- function() {
  devtools::build_readme()
  pkgdown::build_site()
  #system("mkdir /net/hafri.hafro.is/export/home/hafri/einarhj/public_html/pkg/fmr")
  system("rm -rf /net/hafri.hafro.is/export/home/hafri/einarhj/public_html/pkg/fmr/*")
  
  system("cp -rp docs/* /net/hafri.hafro.is/export/home/hafri/einarhj/public_html/pkg/fmr")
  system("chmod -R a+rX /net/hafri.hafro.is/export/home/hafri/einarhj/public_html/pkg/fmr")
}
